# usage: letternum.rb a aa az
#	output: 1,27,52

puts ARGV.map{|str|
	str.chars.map{|c|c.downcase.ord-96}.inject{|m,c|m*26+c}
}.join(',')
