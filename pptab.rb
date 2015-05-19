#!/usr/bin/env ruby

require 'optparse'

options = {
	:separater => "\t",
	:formatfile => 'pptab-format.txt',
}

optparse = OptionParser.new do |opts|
	opts.banner = 'Usage: pptab [options] files'
	
	opts.on('-h', '--help', 'display this screen') do
		puts opts
		puts <<EOF
Format file:
  [First|Last]Name = 20
  IsPrimaryKey = IsPk, 5
  
EOF
		exit
	end
	
	opts.on('-s', '--separater S', 'specify input separater, default is tab') do |s|
		options[:separater] = s
	end
	
	opts.on('-f', '--format FILE', 'specify format file') do |file|
		options[:formatfile] = file
	end
	
	opts.on('-o', '--output FILE', 'output to file instead of stdout') do |file|
		options[:output] = file
	end
	
	opts.on('-t', '--trim', 'trim spaces') do
		options[:trim] = true
	end
end

optparse.parse!

# column related settings can be either stored in a map
# or in a list, depending on how is the header pattern
# specified.

# text_format is a header text to column width map
$text_format = {}

# header rename is a header text to new header name map
$header_rename = {}

# pattern_format is a header pattern to detail translation
# include width and possiblly other information
$pattern_format = []


def find_width(head)
	width = $text_format[head.downcase]
	return width if width
	$pattern_format.each_index do |i|
		f = $pattern_format[i]
		regex = f[:re] || f[:re] = Regexp.new(f[:pattern], true)
		return f[:width] if regex.match(head)
	end
	return nil
end

def find_header_rename(header)
	rename = $header_rename[header.downcase]
	return rename if rename
	$pattern_format.each_index do |i|
		f = $pattern_format[i]
		regex = f[:re] || f[:re] = Regexp.new(f[:pattern], true)
		return f[:rename] if regex.match(header)
	end
	return nil
end

def parse_format(arg)
	if arg =~ /(\S+)\s*=\s*(\d+)\s*$/
		# puts "pattern 1: #{arg}"
		pattern, width = $1, $2
		if pattern =~ /^[\w#]+$/
			$text_format[pattern.downcase] = width.to_i
		elsif
			$pattern_format.push({:pattern => pattern, :width=> width.to_i})
		end
	elsif arg =~ /(\S+)\s*=\s*(\w+)\s*$/
		# puts "pattern 2: #{arg}"
		pattern, rename = $1, $2
		if pattern =~ /^[\w#]+$/
			$text_format[pattern.downcase] = rename.size
			$header_rename[pattern.downcase] = rename
		elsif
			$pattern_format.push({:pattern => pattern, :width=> rename.size, :rename=>rename})
		end
	elsif arg =~ /(\S+)\s*=\s*(\w+)\s*,\s*(\d+)\s*$/
		# puts "pattern 3: #{arg}"
		pattern, rename, width = $1, $2, $3
		if pattern =~ /^[\w#]+$/
			$text_format[pattern.downcase] = width.to_i
			$header_rename[pattern.downcase] = rename
		elsif
			$pattern_format.push({:pattern => pattern, :width=> width.to_i, :rename=>rename})
		end
	end
end

ARGV.delete_if {|arg| parse_format(arg) }

if File.exist? options[:formatfile]
	File.open(options[:formatfile], 'r') do |f|
		while line = f.gets
			parse_format(line)
		end
	end
end

#ARGV.each do |arg|
#	puts 'unparsed ' + arg
#end

field_count = 0
field_width = []

outf = options[:output] ? File.new(options[:output], 'w') : STDOUT

ARGF.each do |line|
	
	line.chomp!
	
	if line.start_with?('--') || line.length == 0
		outf.puts line
		field_count = 0
		next
	end
	
	fields = line.split(options[:separater], -1)
	is_header = false
	if fields.length != field_count
		# puts "parsing new headers #{line}, field count=#{fields.length}"
		if fields.all? {|f|f=~/[a-z]\w*/i}
			fields.each_index do |i|
				field_width[i] = find_width(fields[i]) || fields[i].length
			end
			is_header = true
			field_count = fields.length
		else
			abort <<EOF
header row pattern is not detected while trying to parse header
  previous field count: #{field_count}
  current filed count: #{fields.length}
  current line #{$.}: #{line}
EOF
		end
	end

	fields.each_index do |i|
		
		text = fields[i]
		
		if is_header
			rename = find_header_rename text
			if rename
				text = rename
			end
		elsif options[:trim]
			text.strip!
		end
		
		if text.length > field_width[i]
			if field_width[i] > 3
				text = text[0, field_width[i] - 3] + '...'
			elsif
				text = text[0, field_width[i]]
			end
		elsif
			text = text.rjust(field_width[i], is_header ? '=' : ' ')
		end
		
		outf.print ' ' if i > 0
		outf.print text
	end
	
	outf.puts
	
end

outf.close if outf != STDOUT
