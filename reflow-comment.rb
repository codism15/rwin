require 'clipboard'
require 'optparse'

$width = 100

options = OptionParser.new do |opts|
    opts.banner = 'Usage: reflow-comment.rb [options]'
    opts.on('-h', '-?', '--help', 'display help') do
        puts opts
        puts <<EOF
Example:
  Read from console and write to clipboard
	ruby reflow-comment.rb -i console -o clip
EOF
        exit
    end

    opts.on('-i', '--input=FILE', 'read input from file; default is clipboard') do |file|
        $input_filename = file
    end

    opts.on('-o', '--output=FILE', 'output to file; default is console') do |file|
        $output_filename = file
    end

	opts.on('-w', '--width=WIDTH', 'specify width; default is 100') do |file|
        $width = file
    end

end

options.parse!

# load source

$prefix = ''
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
	content = Clipboard.paste.encode('utf-8')
	content.split(/\r?\n/u).each {|line|load_source_line(line)}
end

abort 'no data is found' if $lines.length == 0

# rerun comment
$output_lines = []
buffer = nil
prefix = nil
indent_prefix = ''
is_new_buffer = false

$lines.each {|line|
	if prefix.nil?
		if line =~ /^(\s*(#|--+|\/\/+|\*+)\s?)/
			prefix = $1
		else
			abort "cannot detect prefix from the first line"
		end
	end
	content = line[prefix.length..-1]

	if content =~ /^(\s+(\d+\.)\s?)/
		# this is an indented block
		indent_prefix = $1
		content = content[indent_prefix.length..-1]
		if !buffer.nil?
			$output_lines << buffer
			buffer = String.new(prefix)
		end
		buffer << indent_prefix
		is_new_buffer = true
	elsif content =~ /^(\s+)/
		# still more spaces after prefix means an indented block
		content = content[$1.length..-1]
	else
		# no more spaces, back to the main block
		if !buffer.nil? && buffer.length > 0
			$output_lines << buffer
			buffer = String.new(prefix)
		end
		indent_prefix = ''
		is_new_buffer = true
	end

	if content.nil? || content.length == 0
		if !buffer.nil? && buffer.length > 0
			$output_lines << buffer
			buffer = String.new(prefix)
			buffer << ' ' * indent_prefix.length if indent_prefix.length > 0
			is_new_buffer = true
		end
		next
	end

	content.split(/\s+/).each {|word|
		if buffer.nil?
			buffer = String.new(prefix)
			buffer << ' ' * indent_prefix.length if indent_prefix.length > 0
			is_new_buffer = true
		elsif word.length + buffer.length + 1 > $width
			$output_lines << buffer
			buffer = String.new(prefix)
			buffer << ' ' * indent_prefix.length if indent_prefix.length > 0
			is_new_buffer = true
		end
		if is_new_buffer
			is_new_buffer = false
		else
			buffer << ' '
		end
		buffer << word
	}
}

if buffer.length > 0
	$output_lines << buffer
end

# output
if defined? $output_filename
	text = $output_lines.join("\n")
	text << "\n"
	if $output_filename.casecmp('clip') == 0
		Clipboard.copy text
	else
		File.write($output_filename, text)
	end
else
	puts $output_lines
end
