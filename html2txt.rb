#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'optparse'
require 'pathname'

optparse = OptionParser.new do |opts|
	opts.banner = 'Usage: html2txt.rb [options] files'
	footer = <<EOF
Example: html2txt.rb -e utf -a out.txt 001.htm 002.htm
EOF
	opts.on('-h', '-?', '--help', 'display this screen') do
		puts opts
		puts
		puts footer
		exit
	end
	
	help = ['output to file(s)',
			'If file name is not given or given as _, input file name',
			'is used to generate output file name.']

	opts.on('-o', '--output [FILE]', *help) do |filename|
		$output_file = filename || '_'
	end
	
	opts.on('-e', '--encoding ENCODING', 'input encoding') do |encoding|
		$input_encoding = encoding
	end
	
	opts.on('-a', '--append [FILE]', 'append to output file') do |filename|
		$append_mode = true
		$output_file = filename
	end
end

optparse.parse!

$filenum = 0
$output_num_format = "%0#{$1.length}d" if $output_file =~ /(#+)/

def is_single_output_file; !$output_num_format; end

def html2txt(io, src_filename)
	$filenum += 1
	doc = Nokogiri::HTML(io, nil, $input_encoding)
	txt = doc.css('body').text
	# txt = txt.gsub(/^\s+$/, "\n")
	if $output_file
		src_base_name = File.basename(src_filename || '-.', '.*')
		output_file = $output_file.gsub('_', src_base_name)
		
		if File.extname(output_file) == ''
			output_file << '.txt'
		end
		
		if $output_num_format
			output_file = output_file.sub(/(#+)/, $output_num_format % $filenum)
		end
		
		# puts "output file #{output_file}"
		
		append_to_file = $append_mode || ($filenum > 1 && is_single_output_file)
		
		# puts "append=#{append_to_file}"
		
		file = open(output_file, append_to_file ? 'a' : 'w')
		
		file.puts txt
		
		file.close
	else
		puts txt
	end
end

if $*.length > 0
	ARGV.each do |filename|
		file = open(filename)
		html2txt file, filename
		file.close
	end
else
	html2txt STDIN
end
