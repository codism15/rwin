#!usr/bin/env ruby
require 'securerandom'
require 'optparse'

DEFAULT_PASSWORD_REQUIREMENT = 'd2l2u2s2'
SPECIAL_CHAR_1 = ',.<>/;:\'"[]{}-_=+~!@#$%&()'
SPECIAL_CHAR_2 = SPECIAL_CHAR_1 + '`|\\*?^'
SPECIAL_CHAR_3 = SPECIAL_CHAR_2 + ' '

$row_number = 8
$col_number = 6
$password_length = 10
$password_requirement = ''

$charset_lower = *('a'..'z')
$charset_upper = *('A'..'Z')
$charset_digit = *('0'..'9')

$special_char = SPECIAL_CHAR_1

$charset_special = ',.<>/?;:\'"[]{}\\|-_=+`~!@#$%^&*() '.scan(/./)

options = OptionParser.new do |o|
    o.banner = 'Usage: pwdgen [options]'
    o.on('-h', '--help', 'display this screen') do
        puts o
        puts <<EOF

Password requirement:
    Password requirement is a string with repeated patterns (class)(num)
      class:    is a letter for character class. 'd' for digits, 'l' for
                lower case letters, 'u' for upper case letters and 's' for
                special characters.
      num:      how many times should the class of characters occur.

    If the requirement string is missing, the default password requirement is
    used: #{DEFAULT_PASSWORD_REQUIREMENT}.

    Note: The default password requirement is not applied unless -r option is
          specified.

Special character:
    There are three nuilt-in special character sets that can be specified
    by -s num:
        0: set special character set to empty
        1: #{SPECIAL_CHAR_1} #the default special characters
        2: #{SPECIAL_CHAR_2} #with some more specific characters
        3: #{SPECIAL_CHAR_3} #with spaces
    User can also specify a set of characters for the -s option:
        -s @@@#!
        specify special character set with three characters and '@' has a 60%
        percent chance being selected when a special character is required.
EOF
        exit
    end
    
    o.on('-r', '--requirement [REQ]', 'specify password requirement') do |req|
        $password_requirement = req || DEFAULT_PASSWORD_REQUIREMENT
    end
    
    o.on('-l', '--length LEN', 'specify password length') do |n|
        $password_length = n.to_i
    end
    
    o.on('-1', '--one', 'output only one password') do
        $row_number = $col_number = 1
    end

    o.on('-s', '--special SPE', 'specify special character set') do |spe|
        if spe =~ /\d/
            case spe.to_i
            when 0 then $special_char = ''
            when 1 then $special_char = SPECIAL_CHAR_1
            when 2 then $special_char = SPECIAL_CHAR_2
            when 3 then $special_char = SPECIAL_CHAR_3
            else
                abort "unknown special character set number #{spe}"
            end
        else
            $special_char = spe
        end
    end
    
    o.parse!
end

$charset_special = $special_char.scan(/./)

$charset_all = $charset_lower + $charset_upper + $charset_digit + $charset_special

def get_password(arr)
    arr[SecureRandom.random_number(arr.length)]
end

def generate_password()
    # arr[SecureRandom.random_number(arr.length)]
    password = []
    
    if $password_requirement.length > 0
        $password_requirement.scan(/(\w)(\d+)/) {|m|
            c, n = $1, $2.to_i
            #puts c, n
            (1..n).each {
                random_char = case c
                    when 'l', 'L' then get_password($charset_lower)
                    when 'u', 'U' then get_password($charset_upper)
                    when 'd', 'D' then get_password($charset_digit)
                    when 's', 'S' then get_password($charset_special)
                    else
                        abort "unknown character class '#{c}' in requirement"
                    end
				password << random_char if random_char
            }
        }
    end
    
    more_chars = $password_length - password.length
	# puts "more chars: #{more_chars}, password: #{password}, #{password.length}"
    while more_chars > 0
        password << get_password($charset_all)
        more_chars -= 1
    end
    
    password.shuffle.join
end

(0...$row_number).each do
    (0...$col_number).each do |index|
        print ' ' if index > 0
        password = generate_password()
        print password
    end
    puts
end

#$charset.each do |c|
#    puts c
#    end
