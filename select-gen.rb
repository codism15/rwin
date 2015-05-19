require 'optparse'

optparse = OptionParser.new do |opts|
	opts.banner = <<EOF
This script takes a two-column input like
table1	column1
table1	column2
table2	column1
table2	column2

and generate sql script as the following:
select column1, column2 from table1;
select column1, column2 from table2;

EOF
	opts.on('-h', '--help', "print this message") do
		puts opts
		exit
	end
end

optparse.parse!

columns = []
current_table_name = nil

$<.each_line do |line|
	table_name, column_name = line.chomp.split
	if current_table_name != table_name
		if current_table_name 
			puts "SELECT #{columns*','} FROM #{current_table_name};"
			columns.clear
		end
		current_table_name = table_name
	end
	columns << column_name
end
puts "SELECT #{columns*','} FROM #{current_table_name};"