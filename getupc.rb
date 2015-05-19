#!/usr/bin/env ruby

$*.each {|a|

	upc = case a.length
		when 15 then a[4..14]
		when 11 then a
		else
			abort("unhandled upc #{a}")
		end
	%x[curl -d "barcode=34&data=#{upc}&size=1&senderid=342134mngh&fbut=Create Barcode" \
		-A "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3" \
		-o tmp.htm -s \
		http://www.barcode-generator.org/]

	abort("error exec curl, code=#{$?}") if $? != 0
	arr = open('tmp.htm').grep(%r|div.+result-img.+src="(.*\.png)"|) {
		puts "downloading image for #{upc}..."
		%x[curl -s http://www.barcode-generator.org#{$1} -o #{upc}.png]
	}
	
	if arr.length == 0
		abort("cannot get upc for #{upc}")
	end
	
}