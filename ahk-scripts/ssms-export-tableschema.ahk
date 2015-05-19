SetMouseDelay, 8
SetKeyDelay, 100, 30

#IfWinActive, Microsoft SQL Server Management Studio, 

^e::
	; assuming a table is selected
	Send, {F2}{Ctrl down}c{Ctrl up}{Esc}
	sleep, 300
	Send, {AppsKey}
	sleep, 500
	Send, s
	sleep, 500
	Send, c
	sleep, 500
	Send, {Enter}
	Sleep, 5000
	Send, {Ctrl down}s{Ctrl up}
	Sleep, 1000
	
	WinWait, Save File As, 
	IfWinNotActive, Save File As, , WinActivate, Save File As, 
	WinWaitActive, Save File As,
	Send, {Ctrl down}v{Ctrl up}{Enter}
	Sleep, 2500

	WinWait, Microsoft SQL Server Management Studio, 
	IfWinNotActive, Microsoft SQL Server Management Studio, , WinActivate, Microsoft SQL Server Management Studio, 
	WinWaitActive, Microsoft SQL Server Management Studio,
	Send, {Ctrl down}{F4}{Ctrl up}
	
	return
