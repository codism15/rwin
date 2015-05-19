#!/usr/bin/ruby

# print column information of the sdf file

require 'execp'

db			=  ARGV[0]
sdfcmd		= "sdfcmd.exe -d '#{db}'"
sdfcmdf		= sdfcmd + ' -f1 --stringwidth=35'

def exece(cmd, input = '')
	execp(cmd, input) {|line| puts line}
end

def normalize_index_name!(line)
	line.gsub!(/(\w+_)(_u?tbl)/) {' ' * $2.length + $1}
	line.gsub!(/(\w+_\w+)(__[0-9A-F]+\.*)/) {' ' * $2.length + $1}
end

puts '-- TABLE LIST --'
sql = 'select TABLE_NAME from INFORMATION_SCHEMA.TABLES'

exece(sdfcmd, sql)

puts '-- COLUMN LIST --'

sql = <<_
select TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS
order by TABLE_NAME, ORDINAL_POSITION
_

exece(sdfcmdf, sql)

puts '-- INDEX LIST --'

sql = <<_
select 'IDX' as [IDX], TABLE_NAME,INDEX_NAME,
	case PRIMARY_KEY when 1 then 'PK' else '' end as [PK],
	case [UNIQUE] when 1 then 'U' else '' end as [UQ],
	COLUMN_NAME from INFORMATION_SCHEMA.INDEXES
order by TABLE_NAME, INDEX_NAME
_

execp(sdfcmdf, sql) { |line|
	normalize_index_name! line
	puts line
}

puts '-- CONSTRAINTS --'

sql = <<_
select TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
order by TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
_

execp(sdfcmdf, sql) { |line|
	normalize_index_name! line
	puts line
}

# referencial constraints somehow are reflected by constraints already

exit

puts '-- REF CONSTRAINTS --'

sql = <<_
select CONSTRAINT_TABLE_NAME,CONSTRAINT_NAME, UNIQUE_CONSTRAINT_TABLE_NAME,UNIQUE_CONSTRAINT_NAME
from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
order by CONSTRAINT_TABLE_NAME,CONSTRAINT_NAME, UNIQUE_CONSTRAINT_TABLE_NAME,UNIQUE_CONSTRAINT_NAME
_
execp(sdfcmdf, sql) { |line|
	normalize_index_name! line
	puts line
}