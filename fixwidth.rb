require 'clipboard'
require 'optparse'

options = OptionParser.new do |opts|
    opts.banner = 'Usage: fixwidth.rb [options]'
    opts.on('-h', '-?', '--help', 'display help') do
        puts opts
        puts <<EOF
Example:
  Read from console and write to clipboard
	ruby fixwidth.rb -i console -o clip
EOF
        exit
    end
    
    opts.on('-i', '--input=FILE', 'read input from file; default is clipboard') do |file|
        $input_filename = file
    end

    opts.on('-o', '--output=FILE', 'output to file; default is console') do |file|
        $output_filename = file
    end

	opts.on('-d', '--delimiter=DELIMITER', 'specify delimiters, default is auto detect') do |n|
        $delimiter_str = n
    end

	opts.on('-c', '--commentwith=COMMENT', 'add comment string to each output line') do |n|
        $comment_str = n
    end
end

options.parse!

# load source

$lines = []

def load_source_line(line)
	return if line =~ /^\s*$/
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
	Clipboard.paste.split(/\r?\n/).each {|line|load_source_line(line)}
end

abort 'no data is found' if $lines.length == 0

# process delimiters
if !(defined? $delimiter_str) || $delimiter_str.length == 0
	# auto detect delimiter
	line = $lines[0]
	# text from query SSMS and Excel uses \t as separator
	if line.index("\t") then $delimiter_str = "\t"
	elsif line.index(",") then $delimiter_str = ","
	elsif line.index("|") then $delimiter_str = "|"
	else
		abort "cannot auto detect delimiter"
	end
end

# split the input by delimiter
$col_max_width = []
$rows = []
$lines.each do |line|
	arr = line.split $delimiter_str
	if $col_max_width.length == 0
		# the header
	end
	# scan for each column width
	arr.each_with_index do |col, i|
		if $col_max_width.length <= i
			$col_max_width.push 0
		end
		# for SQL date text
		text = case
			when col =~ /[-0-9]{10} 00:00:00.000/ then arr[i] = col.gsub(' 00:00:00.000', '')
			else col
			end

		if $col_max_width[i] < text.length
			$col_max_width[i] = text.length
		end
	end
	$rows.push arr
end

# prepare output
$output_lines = []
$rows.each do |row|
	line = String.new
	line << $comment_str if defined? $comment_str
	row.each_with_index do |col, i|
		line << ' ' if line.length > 0
		line << col.ljust($col_max_width[i])
	end
	$output_lines.push line
end

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
