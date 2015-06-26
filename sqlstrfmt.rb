require 'clipboard'
require 'strscan'
require 'logger'

$log = Logger.new(STDERR)

$log.level = Logger::DEBUG

str = Clipboard.paste
str = str.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '')
ending = str.index("\0")
if ending != nil && ending >= 0
	str = str.slice(0, ending)
end

$log.debug "input: #{str}"

arr = []

s = StringScanner.new(str)

while !s.eos? do
	arr << s.scan(/[^']+/)
	arr << s.scan(/'/)
	# entering a string
	while !s.eos? do
		last_match = s.scan_until(/'|@@?[_a-z][_a-z0-9]*|[_a-z][_a-z0-9]*\([^\)]*\)/i)
		matched = s.matched
		arr << last_match.slice(0..-matched.length-1)
		if matched == "'"
			arr << "'"
			if s.peek(1) == "'"
				# double quote
				s.getch
			else
				# the quote was closing the string
				break
			end
		else
			arr << "' + cast(#{matched} as nvarchar) + '"
		end
	end
end

output = arr.join
output.gsub!(" + ''", '')

Clipboard.copy output
