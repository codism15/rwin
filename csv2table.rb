# This script is used to generate T-SQL scripts that imports the given csv file
# into a database. The script scans the first n rows of the csv file to determine
# the column types. It is possible that a detected column length is less than the
# necessary column length for all rows.
# Note: early sql server versions (2017?) bulk insert has a poor CSV support, for
# CSV with field quotation marks, the generated script cannot properly import them.

require 'csv'
require 'yaml'

csv_filename = ARGV[0]

class ColumnInfo
    attr_accessor :name
    attr_accessor :index    # column index
    attr_accessor :types    # array of all possible data types
    attr_accessor :nullable
    attr_accessor :max_length
    attr_accessor :min_length

    def initialize(name, index)
        @name = name
        @index = index
        # types is initialized as all possible types at first then impossible
        # types are removed from the list as data is seen.
        @types = ['boolean', 'int', 'decimal', 'uniqueidentifier']
        @max_length = 20
    end

end

columns = []
row_number = 0

CSV.foreach(csv_filename) {|row|
    row_number += 1
    break if row_number > 1000
    if columns.length == 0
        columns = row.each_with_index.map {|column_name, index| ColumnInfo.new(column_name, index)}
    else
        # for each column, guess the field type
        columns.each{|column|
            value = row[column.index]
            if value.length == 0 || value == 'NULL'
                column.nullable = true
            else
                if value.length > column.max_length
                    column.max_length = 2 * column.max_length
                end
                types = column.types
                types.delete_if {|type|
                    if type == 'boolean'
                        retv = value !~ /^(1|0)$/i
                    elsif type == 'int'
                        value.length > 10 || value != /^-?[0-9]$/
                    elsif type == 'decimal'
                        value !~ /^-?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)$/
                    elsif type == 'uniqueidentifier'
                        retv = value.length != 36 || value !~ /^[0-9a-f]{8}-[0-9a-f]{4}-[-0-9a-f]+$/i
                    else
                        abort "unhandled data type #{type}"
                    end
                }
            end
        }
    end
}

sql_col_defs = columns.map {|column|
    # puts column.name
    types = column.types
    if types.length == 1
        "  #{column.name} #{types[0]}"
    else
        if column.max_length && column.max_length > 8000
            "  #{column.name} nvarchar(max)"
        else
            "  #{column.name} nvarchar(#{column.max_length})"
        end
    end
    #        abort "column #{column.name}, unhandled possible type combination #{types.join(', ')}"
}

table_name = File.basename(csv_filename, ".*").gsub('-', '_')

puts <<-EOF
-- DROP TABLE IF EXISTS #{table_name}

create table #{table_name} (
#{sql_col_defs.join(",\n")}
);

bulk insert #{table_name}
from '#{File.expand_path(csv_filename)}'
with (
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0a',  -- this needs to be verified with the inbound file
  ROWS_PER_BATCH = 10000,
  FIRSTROW = 2,
  TABLOCK
)

EOF
