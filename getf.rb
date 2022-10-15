store_file = Dir.home + '/pushf.txt'

IO.foreach(store_file, chomp: true) {|line|
    print line
    print "\0"
}
