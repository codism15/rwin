# This script starts cygwin's ssh-agent if it is not started. Windows 10 comes
# with ssh client tools. The two sets of ssh clients don't work with each other.
# To see which one you are using, use `where ssh` in command line. To use
# cygwin's ssh tools, the cygwin path needs to be in front of the windows path.
#
# If using Windows 10's ssh client, this script is not needed. Just make sure
# ssh-agent service is running. The following is the PS script to check
# ssh-agent service in Windows 10:
#
#   get-service -name ssh-agent
#
# Note: in Services list, Windows' ssh-agent is named as "OpenSSH Authenti..."

# need pgrep, cygwin package: procps

agent_pid=`pgrep -x ssh-agent`

if agent_pid.length > 0
    agent_pid.chomp!
    puts "SSH Agent already running, pid: #{agent_pid}"
    exit
end

scripts = `ssh-agent`

scripts.each_line {|line|
    line.chomp!
    if line =~ /^(SSH_\w+)=([^;]+);/
        var_name = $1
        var_value = $2
        puts "set #{var_name}=#{var_value}"
        `setx #{var_name} #{var_value}`
    end
}
