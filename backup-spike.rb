
# In LEGO Education SPIKE 3.3, the software automatically saves files very
# often, even when no changes have been made by the user. While this behavior is
# suitable for beginners, it can lead to challenges for those who regularly
# switch between multiple computers and use other software to synchronize files
# across different machines. The issue arises when an older file version, due to
# more frequent auto-saves, acquires a newer timestamp, potentially overwriting
# the genuinely newer version on another computer. To address this, the provided
# script serves to alleviate such concerns by maintaining a local backup of the
# SPIKE code folder.
#
# To use this script for the first time on a computer:
#   1. Create a local backup directory. This directory should not be shared among
#      multiple computers.
#   3. Optional but strongly suggested, initialize the backup folder with git.
#   4. Setup a shortcut or batch to run this script with the working directory
#      set to the SPIKE code folder and the local backup directory as the
#      command parameter.
#
# After setting up the backup, run the shortcut everytime while working with
# SPIKE software. The script will do the following periodically:
#
#   1. scan the code folder for any new change.
#   2. extract the python code from any new change in llsp3 files, if the change
#      was one minute old. This is to avoid too frequent backup.
#   3. auto commit the change in the backup folder if git repository is found.
#
# This script depends `unzip` command line tool. It can be found in many command
# line packages like git or cygwin

require 'fileutils'
require 'json'

#$spike_dir = '.'
def log(message)
    puts "#{Time.now.strftime('%H:%M')}: #{message}"
end

# this is is local repo for backup
$backup_repo = $*.delete_at($*.index{|x|Dir.exist?(x)} || 9999)

raise RuntimeError.new("local backup directory needs to be passed as command line parameter") if !$backup_repo

def scan()
    change_count = 0

    Dir.glob("*.llsp3") {|filename|
        basename = File.basename(filename, ".*")
        dest_dir = "#{$backup_repo}/#{basename}"
        FileUtils.mkdir_p(dest_dir)
        icon_filename = "#{dest_dir}/icon.svg"
        if (Time.now - File.mtime(filename)) > 60 && (!File.exist?(icon_filename) || File.mtime(filename) > File.mtime(icon_filename))
            log "unzipping #{filename}"
            system %[unzip -oq "#{filename}" -d "#{dest_dir}"]
            # it seems files may have feature times
            FileUtils.touch(icon_filename)

            if File.exist?("#{dest_dir}/projectbody.json")
                projectbody = JSON.parse(File.read("#{dest_dir}/projectbody.json"))
                File.write("#{dest_dir}/#{basename}.py", projectbody['main'])
                change_count += 1
            end
        end
    }

    if change_count > 0 && Dir.exist?("#{$backup_repo}/.git")
        log "auto commit"
        Dir.chdir($backup_repo) {
            system %[git add .]
            system %[git commit -m "auto commit"]
        }
    end
end

log "== started, press CTRL-C to stop"
while true
    scan()
    sleep(60)
end