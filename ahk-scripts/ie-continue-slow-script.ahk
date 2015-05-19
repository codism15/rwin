; don't forget to stop this script

^9::
	loop 9 {
		WinWait, Windows Internet Explorer, 
		IfWinNotActive, Windows Internet Explorer, , WinActivate, Windows Internet Explorer, 
		WinWaitActive, Windows Internet Explorer, 
		MouseClick, left,  227,  138
		Sleep, 100
	}
	Msgbox, IE continue slow script loop is end
	return
	
^0::
	loop 30 {
		WinWait, Windows Internet Explorer, 
		IfWinNotActive, Windows Internet Explorer, , WinActivate, Windows Internet Explorer, 
		WinWaitActive, Windows Internet Explorer, 
		MouseClick, left,  227,  138
		Sleep, 100
	}
	Msgbox, IE continue slow script loop is end
	return