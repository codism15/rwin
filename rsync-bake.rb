#!/usr/bin/env ruby

abort 'require ruby 1.9 or higher' if RUBY_VERSION[/\d+\.\d+/].to_f < 1.9

require 'optparse'
require 'pathname'
require 'date'

$verbose = false
$backup_interval = 'daily'
$rsync_options = []

def v(msg)
	puts msg if $verbose
end

def get_projected_backup_dir()
	time = DateTime.now
	format = case $backup_interval
		when 'daily' then '%Y%m%d'
		when 'weekly'
			time -= time.wday * 24 * 3600
			'%Y%m%d'
		when 'monthly' then '%Y%m01'
		when 'quarterly'
			time = DateTime.new(time.year, (time.month-1)/3+1, 1)
			'%Y%m%d'
		when 'yearly' then '%Y0101'
		else abort "Unsupported backup interval: #{$backup_interval}"
	end
	time.strftime(format)
end

# test if the given dir is a root path
def is_root(dir)
	dir == '/' || dir == '\\'
end

def combine_path(dir1, dir2)
	dir = dir1.dup
	dir << '/' if dir[-1] != '/' && dir[-1] != '\\'
	dir << dir2
	dir
end

def load_option_file(filename)
	File.open(filename).
		readlines().
		reject{|line|line[0] != '-'}.
		map{|line|line.chomp} * ' '
end

optparse = OptionParser.new do |opts|
	opts.banner = <<EOF
Usage: rsync-backup-helper.rb [options] srcdir backupdir'

Example:
  rsync-backup-helper.rb -p -m daily C:/mywork E:/mywork-backup

    Note: src and backup dirs are assumed to be absolute paths.
EOF
	
	opts.on('-h', '-?', '--help', 'display this screen') do
		puts opts
		exit
	end
	
	opts.on('-v', '--verbose', 'verbose mode on') do
		$verbose = true
	end
	
	opts.on('-o', '--output FILE', 'output script to file') do |v|
		$output_file = v
	end
	desc = <<EOF

	Generate script that uses windows pushd.  On Windows + cygwin,
	pushd is always used. But if for any reason the program canot
	automatically set the flag, this option is to set the flag to
	use pushd.
EOF
	opts.on('-p', '--pushd', desc) do |v|
		$use_pushd = true
	end
	
	desc = <<EOF

	Append for additional rsync options. OPTIONS starts with '-' is
	directly appended to the generated command line; If option does
	not start with dash, the option text is treated as a file name.
    A sample rsync option file content:
	  # in an option file, any line that does not start
	  # with '-' is considered as comment and ignored.
	  -v --delete --delete-excluded
	  --exclude *~
	  --exclude Thumbs.db
EOF
	opts.on('-r', '--rsync-options OPTIONS', desc) do |v|
		$rsync_options << v
	end

	desc = <<EOF

	Specify backup mode. Currently the following mode are surrported:
	daily, weekly, monthly, quarterly and yearly.
EOF
	opts.on('-m', '--mode MODE', desc) do |v|
		$backup_interval = v
	end

end

optparse.parse!

src_dir, bak_dir = ARGV

src_dir || abort('source dir is required')
bak_dir || abort('backup dir is required')
abort("source is not a directory") if not File.directory? src_dir

v "srcdir: #{src_dir}"
v "back_dir: #{bak_dir}"

if not Dir.exist? bak_dir
	Dir.mkdir bak_dir
end

src_path = Pathname.new src_dir
bak_path = Pathname.new bak_dir

bak_dir_prefix = is_root(src_path.basename.to_s) ? '' : src_path.basename.to_s

v "bak_dir_prefix: #{bak_dir_prefix}"

# find existing backup folders
all_bak_dirs = Dir.chdir(bak_dir) do
	Dir["#{bak_dir_prefix}-*"].select{|p|File.directory? p}
end

projected_bak_dir = "#{bak_dir_prefix}-#{get_projected_backup_dir()}"

v "all_bak_dirs.length: #{all_bak_dirs.length}"

if projected_bak_dir == all_bak_dirs[-1]
	current_bak_dir = projected_bak_dir
	link_dir = all_bak_dirs[-2]
else
	current_bak_dir = projected_bak_dir
	link_dir = all_bak_dirs[-1]
end

full_current_bak_dir = combine_path(bak_dir, current_bak_dir)

v "current_bak_dir: #{current_bak_dir}"
v "full_current_bak_dir: #{full_current_bak_dir}"
v "link_dir: #{link_dir}"

src_dir = File.expand_path src_dir

if src_dir=~/^[a-z]:/i
	$use_pushd = true if not $use_pushd
	src_dir = src_dir.gsub(/^([a-z]):/i, '/cygdrive/\1')
end

src_dir = src_dir.gsub(/\\/, '/')

# prepare command lines

cmd = ''
cmd << %Q[pushd "#{full_current_bak_dir.gsub(/\//, '\\')}"\n] if $use_pushd
cmd << "rsync -H -rt --no-perms --chmod=ugo=rwX"

# read additional rsync options
$rsync_options.each do |option_text|
	cmd << ' '
	if option_text[0] == '-'
		cmd << option_text
	else
		cmd << load_option_file(option_text)
	end
end

cmd << " --link-dest=../#{link_dir}" if not link_dir.nil?

# rsync manual: a trailing slash on the source changes this behavior to
# avoid  creating  an  additional  directory  level  at  the destination.

src_dir << '/' if src_dir[-1] != '/'

cmd << %Q[ "#{src_dir}"]

if $use_pushd
	Dir.mkdir full_current_bak_dir if not Dir.exist? full_current_bak_dir
	cmd << " ."
else
	cmd << " #{bak_dir}/#{current_bak_dir}"
end

cmd << "\n"

cmd << "popd" if $use_pushd

if $output_file
	File.open($output_file, "w") {|out|
		out.puts cmd
	}
else
	puts cmd
end