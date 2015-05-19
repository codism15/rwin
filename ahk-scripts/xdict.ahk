#IfWinActive,

#x::
	Run, "C:\Program Files\Kingsoft\PowerWord_Oxford2010\XDict.exe"
	WinWait, Kingsoft PowerWord 2010, 
	IfWinNotActive, Kingsoft PowerWord 2010, , WinActivate, Kingsoft PowerWord 2010, 
	WinWaitActive, Kingsoft PowerWord 2010, 
	MouseClick, left,  159,  85
	return
#+X::
	Run, "C:\Program Files\Kingsoft\PowerWord_Oxford2010\XDict.exe"
	WinWait, Kingsoft PowerWord 2010, 
	IfWinNotActive, Kingsoft PowerWord 2010, , WinActivate, Kingsoft PowerWord 2010, 
	WinWaitActive, Kingsoft PowerWord 2010, 
	MouseClick, left,  496,  519
	Sleep, 200
	Send, {ESC}
	Sleep, 300
	Send, {ESC}
	return
