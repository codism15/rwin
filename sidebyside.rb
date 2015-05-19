#!/usr/bin/env ruby

$arr = []

ARGV.each {|arg|
	data = []
	File.foreach(arg) {|line|
		row = line.chomp.split "\t"
		data.push row
	}
	$arr.push data
}

abort 'missing input file' if $arr.length == 0

$arr[0][0].each_with_index {|column, column_index|
	$arr[0].each_with_index {|row, row_index|
		$arr.each_with_index {|data, index|
			print "\t" if index > 0
			print data[row_index][column_index]
		}
		puts
	}
	puts
}