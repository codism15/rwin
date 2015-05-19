SetTitleMatchMode, 2
SetKeyDelay, 100, 30,

supercopy() {
	Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
	Sleep, 50
	WinActivate, Untitled - Notepad
	WinWaitActive, Untitled - Notepad
	Send, {CTRLDOWN}v{CTRLUP}
	WinActivate, - Mozilla Firefox
	WinWaitActive, - Mozilla Firefox
	Send, {CTRLDOWN}w{CTRLUP}
	return
}

#IfWinActive, - Mozilla Firefox

^+C::	supercopy()

^+!C::
	loop 4 {
		supercopy()
		sleep, 1000
	}
	return
