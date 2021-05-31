# It seems this script is no longer needed on Windows 10 because Win 10 comes
# with ssh-agent service. Just make sure ssh-agent service starts manually
# and run ssh-agent once at boot time. The following is the PS script to check
# and set ssh-agent service in Windows 10:
#
#   get-service -name ssh-agent | set-service -StartupType Manual

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
