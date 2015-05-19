SetDefaultMouseSpeed, 6
SetTitleMatchMode, 2
SetKeyDelay, 1, 1,

#include common.ahi

show_display_property() {
	Run, "desk.cpl"
	WinWait, Screen Resolution, 
	IfWinNotActive, Screen Resolution, , WinActivate, Screen Resolution, 
	WinWaitActive, Screen Resolution, 
}

#IfWinActive

#^f4::
	show_display_property()
	Send, {ALTDOWN}m{DOWN}{ALTUP}e{ENTER}
	WinWait, Display Settings, 
	IfWinNotActive, Display Settings, , WinActivate, Display Settings, 
	WinWaitActive, Display Settings, 
	SetKeyDelay, 100, 30,
	Send, k
	Sleep, 500
	Run, "C:\Program Files (x86)\MMTaskbar\MultiMon.exe"
	return
#+f4::
	Run, "%UTILS_HOME%\process" -q MultiMon.exe
	show_display_property()
	Send, {ALTDOWN}m{DOWN}{ALTUP}s{ENTER}
	WinWait, Display Settings, 
	IfWinNotActive, Display Settings, , WinActivate, Display Settings, 
	WinWaitActive, Display Settings, 
	SetKeyDelay, 100, 30,
	Send, k
	return

#f4::	Run, "desk.cpl"
