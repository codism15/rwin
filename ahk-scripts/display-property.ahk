SetDefaultMouseSpeed, 6
SetTitleMatchMode, 2

show_display_property() {
	Run, "desk.cpl"
	WinWait, Display Properties, 
	IfWinNotActive, Display Properties, , WinActivate, Display Properties, 
	WinWaitActive, Display Properties, 
	MouseClick, left,  277,  37
}

#IfWinActive

#f4::	
	show_display_property()
	MouseMove, -30, 100, , R
	MouseClick, left
	Send, {Alt Down}e{Alt Up}{Alt Down}a{Alt Up}
	WinWaitClose, Display Properties, , 60
	if !ErrorLevel
		Run, "C:\Program Files\MMTaskbar\MultiMon.exe"
	return
#+f4::
	Run, "%UTILS_HOME%\process" -q MultiMon.exe
	show_display_property()
	MouseMove, -100, 100, , R
	MouseClick, left
	Send, {Alt Down}e{Alt Up}{Alt Down}a{Alt Up}
	return

#^f4::	Run, "desk.cpl"
	
#IfWinActive, Display Properties,
^LEFT::	MouseClickDrag, left, 280, 140, 120, 140, 3,