#!/usr/bin/env ruby

# On Windows:
# - use single quote to avoid auto wildcard expansion
# - use unix path separator

require 'pathname'
require 'date'
require 'optparse'

src_dir, repository_dir = ARGV

now = DateTime.now

src_dir_name = File.basename(File.expand_path(src_dir))

backup_dir_pattern = File.join(repository_dir, "#{src_dir_name}-*")
backup_target_dir = File.join(repository_dir, "#{src_dir_name}-#{now.strftime('%Y-%m-%d')}")

#puts backup_dir_pattern
#puts backup_target_dir

ref_dir = get_ref_dir(backup_dir_pattern, backup_target_dir)

# array to receive new arguments
args = %w[rsync -H -rvt --no-perms]

if !ref_dir.nil?
    # Note: we have ref_dir as absolute path now. if ref_dir is relative, it is
    # relative to the destination.
    args << single_quote_filename("--link-dest=#{handle_windows_dir(ref_dir)}")
end

args << single_quote_filename(ensure_ending_slash(handle_windows_dir(File.expand_path(src_dir))))
args << single_quote_filename(handle_windows_dir(backup_target_dir))

cmd = args.join(' ')
puts cmd
puts %x[#{cmd}]
if $?.success?
    remove_old_backups(backup_dir_pattern)
end

BEGIN {

    # Using File.mtime can get the source directory timestamp because rsync
    # might have preserved the original timestamp. We need to parse the file
    # name to get the time that the backup was created for sorting and pruning.
    # An example of backup directory name:
    #   /mnt/media/backup/work-2019-03-01
    def get_time_from_filename(name)
        if name =~ /-(\d{4})-(\d\d)-(\d\d)/
            year, month, day = $1.to_i, $2.to_i, $3.to_i
            t = Time.new(year, month, day)
            # puts "getting time #{t} for #{name}"
            return t
        else
            raise RuntimeError, "Cannot get time from #{name}"
        end
    end

    # this is to get the recent backup dir that is to be used for --link-dest.
    # This dir is sometimes called reference dir in this script.
    def get_ref_dir(backup_dir_pattern, backup_target_dir)
        arr = Dir.glob(backup_dir_pattern.gsub('\\', '/'))\
            .select {|n|File.directory?(n)}\
            .sort_by {|n|get_time_from_filename(n)}
        return nil if arr.length == 0
        # find the target dir in the sorted backup directories.
        target_dir_basename = File.basename(backup_target_dir)
        idx = arr.index{|n|File.basename(n) == target_dir_basename}
        # if target dir didn't exist, the reference dir should be the last in
        # the list.
        return arr[-1] if idx.nil?
        # if target dir is found at the beginning of the list, there was no last
        # reference dir.
        return nil if idx == 0
        # if target dir is found in the middle of the list, the reference dir
        # should be the dir in front of it
        return arr[idx - 1]
    end

    def remove_old_backups(backup_dir_pattern)
        # hard coded to remove folder older than 30 days for now
        d = Time.now - 30 * 24 * 3600

        arr = Dir.glob(backup_dir_pattern.gsub('\\', '/'))\
            .select {|n|File.directory?(n) && get_time_from_filename(n) < d}

        arr.each {|n|
            puts "Should remove old backups: #{n}"
        }
    end

    def single_quote_filename(name)
        return %['#{name}']
    end

    # a windows full path includes ':', which confuses rsync to think it is a
    # remote directory. When rsync sees source and destination are both remote, it
    # throws error: The source and destination cannot both be remote.
    def handle_windows_dir(path)
        # if a path is not a windows absolute path, no need to do any conversion
        path = path.gsub('\\', '/')
        return path if path !~ /^[a-z]:/i
        return path.gsub(/^([a-z]):/i, '/cygdrive/\1')
    end

    def ensure_ending_slash(path)
        return path[-1] == '/' || path[-1] == '\\' ? path : (path + '/')
    end
}