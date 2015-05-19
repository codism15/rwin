#IfWinActive, ahk_class VNCviewer

^TAB::
	MouseClick, left,  196,  37
	Sleep, 100
	Send, {TAB}
	MouseClick, left,  196,  37
	Sleep, 100
	return