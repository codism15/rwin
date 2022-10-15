store_file = Dir.home + '/pushf.txt'

File.open(store_file, 'w') {|f|
    if $*.length > 0
        $*.each {|filename|
            f.puts File.absolute_path(filename)
        }
    else
        $stdin.each(chomp: true) {|filename|
            f.puts File.absolute_path(filename)
        }
    end
}
