require 'uri'
require 'optparse'

optparse = OptionParser.new do |opts|
	opts.banner = 'Usage: jsm2bookmarklet.rb [options] file'
	footer = <<EOF
uglifyjs my.bookmarklet.js | jsm2bookmarklet.rb
EOF
	opts.on('-h', '-?', '--help', 'display this screen') do
		puts opts
		puts
		puts footer
		exit
	end
	
	opts.on('-o', '--output [FILE]', 'specify output file') do |filename|
		$output_file = filename
	end
	
	opts.on('-u', '--url', 'Output .url file') do
		$output_url = true
	end
end

optparse.parse!

js = $<.readline
js = URI.escape(js)
js = "javascript:(function(){#{js}})();"

output_str = if $output_url then "[InternetShortcut]\nURL=#{js}" else js end

if $output_file
	File.open($output_file, 'w') {|f| f.write(output_str)}
else
	print output_str
end
