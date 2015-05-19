SetDefaultMouseSpeed, 6
SetTitleMatchMode, 2
SetKeyDelay, 10, 10

click_property_tab_then_filename()
{
	Sleep, 50
	MouseClick, left,  102,  35
	Sleep, 100
	
	MouseClick, left,  269,  100
	Sleep, 100
}

click_meta_tab()
{
	Sleep, 50
	MouseClick, left,  53,  35
	Sleep, 100
}

; auto fill track title and track number by the file name
; the file name is assumed to have pattern like nn-title.wav
; tested in windows 7 64, foobar 2000 v1.2.1
track_title_number_by_file_name()
{
	IfWinNotActive, foobar2000
	{
		MsgBox, expecting foobar2000 window active
		return
	}
	Send, {ALTDOWN}{ENTER}{ALTUP}
	Sleep, 50
	WinWait, Properties -
	IfWinNotActive, Properties -, , WinActivate, Properties -, 
	WinWaitActive, Properties -,
	
	click_property_tab_then_filename()
	Send, {CTRLDOWN}c{CTRLUP}

	click_meta_tab()
	
	MouseClick, left,  160,  91
	Sleep, 100
	Send, {CTRLDOWN}v{CTRLUP}
	Send, {BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{HOME}{DEL}{DEL}{DEL}{TAB}

	MouseClick, left,  146,  210
	Sleep, 100
	
	Send, {CTRLDOWN}v{CTRLUP}
	Send, {HOME}{RIGHT}{RIGHT}{SHIFTDOWN}{END}{SHIFTUP}{DEL}{TAB}
	
	Send, {ALTDOWN}o{ALTUP}
}


#IfWinActive, foobar2000
^r::
	track_title_number_by_file_name()
	return
^+R::
	loop 5
	{
		track_title_number_by_file_name()
		Sleep, 500
		Send, {DOWN}
		Sleep, 100
	}
	return
