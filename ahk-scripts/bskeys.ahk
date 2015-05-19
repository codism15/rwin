#IfWinActive

winid=0

validate_winid() {

	global winid
	
	if winid = 0
		return

	DetectHiddenWindows, On
	
	IfWinNotExist, ahk_id %winid%
		winid=0
}

!`::
	validate_winid()
	
	if (winid = 0)
		return

	; test if the window is hidden
	isHidden = 0
	DetectHiddenWindows, Off
	IfWinNotExist, ahk_id %winid%
		isHidden = 1
	
	if isHidden
	{
		WinShow, ahk_id %winid%
		WinActivate, ahk_id %winid%
	}
	else
	{
		WinHide, ahk_id %winid%
	}	

	return
	
!^`::
	winid := WinExist("A")

	if winid = 0
		MsgBox Cannot get the current window

	return