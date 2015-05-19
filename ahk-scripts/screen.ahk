; this script is not used and will be deleted in future. 1/2/2011
#f1::
	Run, "desk.cpl"
	WinWait, Display Properties, 
	IfWinNotActive, Display Properties, , WinActivate, Display Properties, 
	WinWaitActive, Display Properties, 
	MouseClick, left,  277,  37
	MouseClick, left,  270,  130
	Sleep, 100
	Send, {ALTDOWN}e{ALTUP}
	return

#+f1::
	Run, "desk.cpl"
	WinWait, Display Properties, 
	IfWinNotActive, Display Properties, , WinActivate, Display Properties, 
	WinWaitActive, Display Properties, 
	MouseClick, left,  277,  37
	MouseClick, left,  150,  130
	Sleep, 100
	Send, {ALTDOWN}e{ALTUP}
	return
