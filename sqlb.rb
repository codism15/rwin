#!/usr/bin/ruby

require 'optparse'

$separator = "\t"

$newline_columns = {}

$target = :insert

NEWLINE_AND_INDENT = "\n    "

optparse = OptionParser.new do|o|

	o.banner = "Usage: sqlb [options] <data file>"

	o.on('-s FILE', '--schema', 'Specify schema file' ) {|f|$schema_file = f}
	o.on('-n COLUMN', '--newline', 'Newline before the column(s)') {|list|
		arr = list.split ','
		arr.each {|c| $newline_columns[c.downcase.to_sym] = true}
	}
	o.on('-t TABLE', '--table', 'Specify table name if no schema file is used') {|t| $table_name = t}
	o.on('-N', 'Newline for each column') {$newline_per_column = true}
	o.on('-u', '--update', 'Generate update script instead of insert') {$target = :update}
	o.on('-i IDSEEDS', '--identity', 'reset identity after insertion') {|ids| $identity_seeds = ids}
	o.on('-k KEYs', 'Specifiy key column') {|keys| $keys = keys}
	o.on('-q', 'output schema query for sqlce') {$schema_query_sqlce = true}
	
	o.on('--verbose', 'Output more information' ) {$verbose = true}
	o.on('--version', 'Display versioning information' ) {puts '0.1';exit}
	o.on('-h', '--help', 'Display this screen' ) {puts o;exit}

	o.parse!
end

if $schema_query_sqlce
	
	abort 'table name is required' if !defined? $table_name
	
	puts <<EOF
	SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, AUTOINC_INCREMENT
	From INFORMATION_SCHEMA.COLUMNS
	Where TABLE_NAME = '#{$table_name}'
EOF
	exit
end

$columns = []

if defined? $schema_file
	File.foreach($schema_file) {|line|
		next if line =~ /^\s*#/
		$table_name, column_name, type, auto_inc = line.chomp.split "\t"
		col = {
			:name => column_name,
			:key => column_name.downcase.to_sym,
			:type => type.downcase.to_sym,
			:is_identity => auto_inc && auto_inc != 'NULL'
		}
		$columns.push col
		$generate_identity_insertion_script = $target == :insert if col[:is_identity]
	}

	# build column name to order map
	$<.gets.chomp.split($separator).each_with_index{|column_name, i|
		col = $columns.find {|c| c[:name] == column_name}
		next if !col
		col[:index] = i
	}
elsif
	# no schema file, build the column list from the first line
	$<.gets.chomp.split($separator).each_with_index{|column_name, i|
		$columns.push({
			:name => column_name,
			:key => column_name.downcase.to_sym,
			:index => i
		})
	}
end

# validate required columns

missing_columns = $columns.select{|col| !col[:index]}

abort 'Missing column(s): ' + missing_columns.map{|col|col[:name]} * ', ' if missing_columns.any?

def intelli_quote(value)
	return "'#{value}'" if value[/^0./]	# 00001234 is a string
	value if Float(value) rescue "'#{escape_single_quote(value)}'"
end

def escape_single_quote(value)
	value.gsub("'", "''")
end

def v(col)
	value = col[:value]
	
    return 'NULL' if value == 'NULL' || value.length == 0

    case col[:type]
        when :int, :bit, :long, :short then "#{value}"
        when :uniqueidentifier then "'#{value}'"
        when :datetime, :smalldatetime then "'#{value}'"
        when :nvarchar, :nchar then "N'#{escape_single_quote(value)}'"
		when :varchar, :char then "'#{escape_single_quote(value)}'"
        else intelli_quote(value)
    end
end

def clean_current_row
	$columns.each {|col| col[:value] = 'NULL'}
end

def join(list, separator, selector)
	
	str = String.new
	
	list.each_with_index {|c, i|
		str << separator if i > 0
		str << NEWLINE_AND_INDENT if $newline_columns[c[:key]] || $newline_per_column
		str << selector.call(c)
	}
	
	return str

end

def track_identity
	$columns.each {|col|
		next unless col[:is_identity]
		col[:max] = [col[:max]||0, col[:value].to_i].max
	}
end

def generate_insert
	column_list = join $columns, ', ', lambda {|c|"[%s]"%c[:name]}
	value_list  = join $columns, ', ', lambda {|c|v(c)}
	sql = <<-EOF
INSERT INTO [#{$table_name}] (#{column_list}) values (#{value_list});
	EOF
end


class SqlServerInsertGenerator
	def initialize()
		reset()
	end
	
	def reset()
		@count = 0
		@sql = String.new
	end
	
	def push()
		value_list  = join $columns, ', ', lambda {|c|v(c)}
		if @sql.length == 0
			column_list = join $columns, ', ', lambda {|c|"[%s]"%c[:name]}
			@sql << "INSERT INTO [#{$table_name}] (#{column_list}) values\n"
			@sql << "  (#{value_list})"
		elsif
			@sql << ",\n  (#{value_list})"
		end
		@count += 1
		if @count == 1000
			puts @sql
			reset()
		end
	end
	
	def final()
		if @count > 0
			puts @sql
			reset()
		end
	end
end

def generate_update
	if !$value_columns
		keys = defined?($keys) ?
			$keys.split(',').map{|k|k.downcase.to_sym} :
			[$columns[0][:key]]
			
		$value_columns = []
		$key_columns = []
		
		$columns.each {|col|
			if keys.any? {|k|k == col[:key]}
				$key_columns << col
			elsif
				$value_columns << col
			end
		}
	end
	
	set_list = join $value_columns, ', ',
		lambda {|c| '[%s]=%s'%[c[:name], v(c)]}
	where_list = join $key_columns, ' AND ',
		lambda {|c| '[%s]=%s'%[c[:name], v(c)]}
	
	sql = <<-EOF
UPDATE [#{$table_name}] SET #{set_list}
  WHERE #{where_list};
	EOF
end

abort 'table name is required' if !defined? $table_name

if $generate_identity_insertion_script
	puts "SET IDENTITY_INSERT [#{$table_name}] ON;"
	puts
end

sqlserver_insert = SqlServerInsertGenerator.new if $target == :insert_multivalues

$<.each {|line|
	arr = line.chomp.split($separator, -1)
	$columns.each {|col|
		col[:value] = arr[col[:index]]
	}
	case $target
		when :insert_multivalues then sqlserver_insert.push
		when :insert then puts generate_insert
		when :update then puts generate_update
		else abort 'unknown target ' + $target
	end
	track_identity if $target == :insert
	clean_current_row
}

sqlserver_insert.final() if (defined? sqlserver_insert) && !sqlserver_insert.nil?

if $generate_identity_insertion_script
	puts
	puts "SET IDENTITY_INSERT [#{$table_name}] OFF;"
	if $identity_seeds
		arr = $identity_seeds.split ','
		if defined? $columns[0].is_identity
			identity_columns = $columns.select{|col|col.is_identity}
		elsif
			identity_columns = [$columns[0]]
		end

		abort "the number of identity columns (#{identity_columns.length}) does not match the number of seeds(#{arr.length})" if
			identity_columns.length != arr.length
		puts
		
		identity_columns.each_with_index {|col, i|
			seed = case arr[i].downcase
				when 'auto' then 1+(col[:max]||abort("the max value of identity column #{col[:name]}' is not set"))
				else arr[i].to_i
			end
			
			puts "ALTER TABLE #{$table_name} ALTER COLUMN #{col[:name]} IDENTITY (#{seed},1);"
		}
	end
end