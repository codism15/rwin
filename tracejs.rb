#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

def v(msg)
	puts msg if $verbose
end

optparse = OptionParser.new do |opts|
	opts.banner = 'Usage: tracejs.rb [options] files'
	
	opts.on('-h', '--help', 'display this screen') do
		puts opts
		exit
	end
	
	opts.on('-v', '--verbose', 'verbose mode on') {$verbose = true}
	opts.on('-o FILE', '--output', "Specify the output file; 'self' update the original file.") {|f| $output = f}
	opts.on('-r', '--remove', "Remove tracing statements.") {$removal_mode = true}
	
end

optparse.parse!


def add_trace(filename)
	abort("#{filename} is not a js file.") if filename !~ /\.js\b/i
	basename = File.basename(filename)
	output_buffer = []
	# When log lines are inserted/deleted from the original, the line number
	# of a function is changed. So a shift is needed to keep track of the
	# number of rows been inserted or deleted to properly calculate the line
	# number in the output file.
	function_line = 0
	function_line_shift = 0
	function_name = ''
	state = :looking
	File.open(filename).each_line do |line|
		case state
		when :looking
			if line =~ /\bfunction\s+(?<name>\w+)\s*\([\w\s,]*\)\s*((?<begin_curl>{)\s*)?$/
				function_name = $~[:name]
				function_line = $. + function_line_shift
				#puts "#{$.}:#{line} ->" + $~[:name]
				state = $~[:begin_curl] ? :found_curl : :waiting_for_curl
			end
			output_buffer << line
		when :waiting_for_curl
			if line =~ /^\s*{\s*$/
				state = :found_curl
			end
			output_buffer << line
		when :found_curl
			code_snippet = "console.log('#{basename}:#{function_line}:#{function_name}')"
			
			if line =~ /^\s*$/
			
				# blank line
				output_buffer << line
				
			elsif line =~ /^(?<leading_space>\s*)console.log\('[-\w:\.]+:#{function_name}'\)/
			
				if !$removal_mode
					output_buffer << "#{$~[:leading_space]}#{code_snippet}"
				end
				state = :looking
				
			elsif line =~ /^(?<leading_space>\s*)\S+/
			
				if !$removal_mode
					output_buffer << "#{$~[:leading_space]}#{code_snippet}"
					function_line_shift += 1
				end
				output_buffer << line
				state = :looking
				
			end
		else
			abort "unhandled state: #{state} on line #{$.}:#{line}"
		end
	end
	
	if !$output
		puts output_buffer
	elsif $output == 'self'
		open(filename, 'w') {|f|f.puts output_buffer}
	else
		open($output, 'w') {|f|f.puts output_buffer}
	end
		
end

ARGV.each {|filename|
	add_trace(filename)	
}
