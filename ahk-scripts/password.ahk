getmasterpwd() {
	global masterpwd
	if masterpwd=
	{
		InputBox, masterpwd, My password manager, Enter the master password, HIDE, 240, 120,
		Sleep, 300
	}
	return masterpwd
}

getmypassword(key) {
	masterpwd := getmasterpwd()
	if !errorlevel
	{
		RunWait, c:\cygwin\bin\bash.exe -c "openssl enc -d -des3 -pass pass:%masterpwd% -in ""$HOME/%key%"" > password.tmp",,Hide
		FileReadLine, passwd, password.tmp, 1
		FileDelete, password.tmp
		return passwd
	}
}

#IfWinActive, Connect to www.crossmarkconnect.com
^l::
	passwd := getmypassword("rui-crossmark.des3")
	MouseClick, left,  165,  172
	send, %passwd%{RETURN}
	return

#IfWinActive, Connect to sps.crossmark.com
^l::
	passwd := getmypassword("rui-crossmark.des3")
	MouseClick, left,  178,  165
	send, %passwd%{RETURN}
	return

#IfWinActive, Connecting to www.crossmarkconnect.com
^l::
	passwd := getmypassword("rui-crossmark.des3")
	MouseClick, left,  165,  172
	send, %passwd%{RETURN}
	return

#IfWinActive,