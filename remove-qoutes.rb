# pgAdmin 3 double quote the data being copied. This script is to remove the double
# quotation marks before paste

require 'clipboard'
require 'optparse'
require 'logger'


Encoding.default_internal = Encoding::UTF_8

$log = Logger.new(STDERR)

options = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
    opts.on('-h', '-?', '--help', 'display help') do
        puts opts
        puts <<EOF
Example:
  Read from console and write to clipboard
	ruby sqlin.rb -i console -o clip
EOF
        exit
    end

    opts.on('-i', '--input=FILE', 'read input from file; default is clipboard') do |file|
        $input_filename = file
    end

    opts.on('-o', '--output=FILE', 'output to file; default is console') do |file|
        $output_filename = file
    end

	opts.on('-l', '--logger [LEVEL]', 'trun on logger') do |level|
        level ||= 'info'
		$log.level =
			if level.casecmp('info') == 0 then Logger::INFO
			elsif level.casecmp('debug') == 0 then Logger::DEBUG
			else abort "unknown log level #{level}"
			end
    end
end

options.parse!

# load source

$lines = []

def load_source_line(line)
	$lines.push line
end

if defined? $input_filename
	if $input_filename.casecmp('console') == 0
		$stdin.each {|line|load_source_line(line)}
	else
		File.foreach($input_filename) {|line|load_source_line(line.chomp)}
	end
else
	# load from clipboard
	str = Clipboard.paste
	$log.debug "clipboard text encoding: #{str.encoding}"
	str = str.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '')
	ending = str.index("\0")
	if ending != nil && ending >= 0
		str = str.slice(0, ending)
	end

	if $log.debug?
		$log.debug "clipboard text length: #{str.length}"
		str.bytes.each_slice(8) {|row|
			$log.debug row.map{|b|sprintf(" 0x%02X",b)}.join
		}
	end
	str.split(/\r?\n/).each {|line|load_source_line(line)}
end

abort 'no data is found' if $lines.length == 0

if $log.debug?
	$lines.each {|line|
		$log.debug("#{line.length}, #{line}")
	}
end

# detect data type

# generate output
$output_lines = []

$lines.each_with_index {|line, index|
	newline = line.gsub(/^"|"$/, '')
	$output_lines.push newline
}

# output
if defined? $output_filename
	if $output_filename.casecmp('clip') == 0
		Clipboard.copy $output_lines.join("\n")
	else
		File.write($output_filename, $output_lines.join("\n"))
	end
else
	puts $output_lines
end
