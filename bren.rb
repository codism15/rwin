require 'optparse'

# futures:
# order by (date, ...)

$trace_on = false

def trace(msg)
    puts msg if $trace_on
end

# format an integer varable. An integer varable has the following parts:
#   1. one or more characters of the name
#    2. an optional format string
# The following are some example:
#    .  .%03d  .%2X
def format_integer_varable(i, var_str, name_length = 1)
    if var_str.length == name_length
        i.to_s
    else
        var_str[name_length..-1] % i
    end
end

options = OptionParser.new do |opts|
    opts.banner = 'Usage: bren.rb [options] files [transformers]'
    opts.on('-h', '-?', '--help', 'display help') do
        puts opts
        puts <<EOF
Ordering:
    Files can be ordered before their names are transformed, which is especial
    useful when the target name involves the internal counter. Following are
    supported ordering options:
        n, name:    order by source file name
        d, date:    order by file modification date
        r, random:  order by random numbers
    A regular expression pattern with a capture can also be used. The following
    are some examples:
        (\\d+)\\.txt/t  order by the number before the extension name, in alphabet
                      order. The data type indicator '/t' can be ommited as it is
                      the default.
        (\\d+)/n       order by the first number found, in numeric order.
    Additionally, a minus sign can follow a sort key to reverse the order.

Transformer:
    A transformer transforms part of a source file name to a target text. A
    transformer consists two parts: source-pattern/target-pattern. Internally,
    String.gsub is used to perform the transformation. Before the transformation,
    program also performs variable substitution. A variable is specified by a
    pair of curly brackets. If it is a single character variable, it can be
    specified by a leading '$' character. The following are supported variables:
      .          An internal counter for each file.
      d, date    File last modification date.
      ?          A random number.
    A ruby format string can follow after a variable. Following are some example:
      {.%03d}    the counter with three digit and leading zeros.
      {d%Y}      the year of the file date 
      {???%03d}  a random number in [0-999]

Examples:
    Grab all text files, order by date and add a number to them:
      bren.rb *.txt -o date \./{.%02d}.
        
EOF
        exit
    end
    
    opts.on('-b', '--basedir=basedir', 'set base directory') do |dir|
        $base_dir = dir
    end

    opts.on('-s', '--randomseed=seed', 'set random generator seed') do |seed|
        $random_seed = seed.to_i
    end

    opts.on('-o', '--order=orderby', 'set order key') do |o|
        $order_by = o
    end

    opts.on('-p', '--preview', 'preview the change only') do
        $preview = true
    end
    
    opts.on('-c', '--counter=number', 'set counter') do |counter_str|
        $counter, $counter_step = counter_str.split(',').map {|s|s.to_i}
    end

    opts.on('--trace', 'print trace or debug information') do
        $trace_on = true
    end
end

options.parse!

# if base dir is not set,set the base dir to the current dir
if defined? $base_dir
    Dir.chdir $base_dir
else
    $base_dir = Dir.pwd
end

trace "Using base dir #{$base_dir}"

# parse file names and patterns from commnad line arguments

transformers = []
source_filenames = {}

ARGV.each {|arg|
    # A command line argument can be a file name or a transformation
    # pattern.
    if arg =~ /([^\/]+)\/(.*)/
        # transformer has the form of 'abc/def'
        from, to = $1, $2
        transformers << [arg, Regexp.new(from, Regexp::IGNORECASE), to]
    elsif arg =~ /^\/([^\/]+)/
        # regular pattern has the form of '/abc'
        reg_pattern = arg[1..-1]
        reg = Regexp.new(reg_pattern, Regexp::IGNORECASE)
        Dir.entries('.').each {|name|
            if reg.match(name)
                source_filenames[name] = true
            end
        }
    elsif arg =~ /[\*\?]/
        # unexpanded glob pattern, form: 'view*.h'
        Dir.glob(arg).each {|name|
            source_filenames[name] = true
        }
    else
        # assume this is a file name
        source_filenames[arg] = true
    end
}

source_filenames.delete '.'
source_filenames.delete '..'

abort "no source file is given" if source_filenames.length == 0

if $trace_on
    trace "Transformers(#{transformers.length}):"
    transformers.each {|t, from, to|
        trace "  #{t}"
    }
end

entries = source_filenames.keys.map {|name|
        {:name => name}
    }

# process default arguments that will be needed for renaming
$preview ||= false
$counter ||= 1
$counter_step ||= 1
rand = (defined? $random_seed) ? Random.new($random_seed) : Random.new

# sort entries

if defined? $order_by
    if $order_by =~ /^n(ame)?/i
        entries.sort_by! {|elm|elm[:name]}
    elsif $order_by =~ /^d(ate)?/i
        entries.sort_by! {|elm| File.mtime(elm[:name])}
    elsif $order_by =~ /^r(andom)?/i
        entries.sort_by! {|elm|rand.rand(1000)}
    elsif $order_by =~ /\(/i
        # the order_by appears like a regular expression with a capture
        pat, type = $order_by.split '/'
        type ||= 'text'
        key_data_type =
            if type =~ /^t(ext)?/i
                :text
            elsif type =~ /^n(umber)?/i
                :number
            else
                abort "unknown sort key data type #{type}"
            end
        regex = Regexp.new(pat)
        entries.sort_by! {|elm|
            match = regex.match elm[:name]
            match_text = match ? match[1] : '0'
            trace "warning: unabled to get sort key for #{elm[:name]}" if !match
            case key_data_type
                when :text then match_text
                when :number then match_text.to_i
                else abort "unknown sort key data type #{key_data_type}"
            end
        }
    end
    if $order_by[-1] == '-'
        entries.reverse!
    end
end

if transformers.length == 0
    # Without transformer, it is assumed the user just want to list
    # the files going to be processed.
    entries.each {|e| puts e[:name]}
    exit
end

entries.each {|e|
    
    new_name = e[:name].dup
    
    transformers.each {|transformer, from, to|
        # parse and replace variable(s) in the 'to' pattern
        replacement = to.gsub(/(\$[^\{])|(\{[^{}]+\})/) {|elm|
            variable = case elm[0]
                when '$' then elm[1]
                when '{' then elm[1..-2]
                else abort "unknown element #{elm} in replacement pattern #{to}"
                end

            if variable[0] == '.'
                format_integer_varable($counter, variable, 1)
            elsif variable =~ /^(\?+)/
                random_var_name = $1
                var_len = random_var_name.length
                format_integer_varable(rand.rand(10 ** var_len), variable, var_len)
            elsif variable =~ /^(d|date)/
                random_var_name = $1
                var_len = random_var_name.length
                File.mtime(e[:name]).strftime(var_len == variable.length ? '%Y%m%dT%H%M%S' : variable[var_len..-1])
            else
                abort "unkonwn variable #{var_name} in transformation #{to}"
            end
        }
        new_name.gsub!(from, replacement)
    }
    e[:new_name] = new_name
    
    $counter += $counter_step
}

# validate no dup in target names
target_hash = {}
entries.each {|entry|
    new_name = entry[:new_name]
    if target_hash.has_key?(new_name)
        $stderr.puts "dup target name detected: "
        $stderr.puts "  #{target_hash[new_name]} -> #{new_name}"
        $stderr.puts "  #{entry[:name]} -> #{new_name}"
        exit 1
    end
    target_hash[new_name] = entry[:name]
}

# validate no dup by checking the disk files
Dir.entries('.').each {|name|
    if target_hash.has_key?(name)
        $stderr.puts "dup target name detected: "
        $stderr.puts "  #{target_hash[name]} -> #{name}"
        $stderr.puts "  Disk: #{name}"
        exit 1
    end
    target_hash[name] = 'Disk'
}

entries.each {|entry|
    name, new_name = entry[:name], entry[:new_name]
    if $preview
        puts "#{name} -> #{new_name}"
    else
        File.rename name, new_name
    end
}









