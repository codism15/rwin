#IfWinActive,

#ENTER::
	SetTitleMatchMode, 1
	IfwInExist, Message from
	{
		WinActivate
		Send, {Enter}
		return
	}
	return
