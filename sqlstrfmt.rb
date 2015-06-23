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
	# scan string
	while !s.eos? do
		arr << s.scan(/[^'@]+/)
		
		c = s.scan(/['@]/)
		nextc = s.scan(/['@]/)
		
		if c == "'"
			arr << "'"
			if nextc == "'"
				# an escaped single quote
				;
			else
				# end of string
				arr << nextc
				break
			end
		elsif c == '@'
			if nextc == '@'
				arr << '@'	# an escaped @
			else
				id = s.scan(/[_a-z][_a-z0-9]*(\(\))?/i)
				if id !~ /\(/
					arr << "' + cast(@#{id} as nvarchar) + '"
				else
					arr << "' + cast(#{id} as nvarchar) + '"
				end
			end
		else
			abort "unhandled #{c}"
		end
	end
end

Clipboard.copy arr.join
