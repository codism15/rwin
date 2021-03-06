SetTitleMatchMode, 2
SetKeyDelay, 30, 1,

#IfWinActive, - Microsoft Visual Studio
^!f::
	Send, {CTRLDOWN}c{CTRLUP}
	RunWait, %RWIN_HOME%\reflow-comment.rb -o clip, , Hide UseErrorLevel
	if !ErrorLevel
		Send, {CTRLDOWN}v{CTRLUP}
	return

^f::
	WinGetPos, , , width, height, A
	ImageSearch, x, y, 2*width/3, 60, width, 140, images\vs2008-solution-explorer-highlighted.png
	if ErrorLevel {
		Send, ^f
	} else {
		Send, {ALTDOWN}f{ALTUP}rc{ENTER}
	}
	return

; disabled because conflict with VirtuaWin hotkeys
;^!LEFT::
;	WinGetPos, , , width, height, A
;	ImageSearch, x, y, 150, 70, width-150, 100, *30 images\vs2008-active-tab-left.png
;	if ErrorLevel {
;		MsgBox, Cannot find active document tab left edge
;	} else {
;		MouseClick, ,x-50, y+10, , 2
;	}
;	return

;^!RIGHT::
;	WinGetPos, , , width, height, A
;	ImageSearch, x, y, 150, 70, width-150, 100, *30 images\vs2008-active-tab-right.png
;	if ErrorLevel {
;		MsgBox, Cannot find active document tab right edge
;	} else {
;		MouseClick, ,x+50, y+10, , 2
;	}
;	return

; pgAdmin 3 double quote the data being copied. This function is to remove the double
; quotation marks before paste
; for some reason, this .sql is not matching the pgAdmin 3 query editor
#IfWinActive, .sql
^'::
	RunWait, ruby "%RWIN_HOME%\remove-quote.rb" -o clip, , Hide
	Send, {CTRLDOWN}{v}{CTRLUP}
	return

; format sql in text
^+V::
	RunWait, ruby "%RWIN_HOME%\sqlin.rb" -w 120 -o clip, , Hide
	Send, {CTRLDOWN}{v}{CTRLUP}
	return

^+B::
	RunWait, ruby "%RWIN_HOME%\sqlin.rb" -o clip -q, , Hide
	Send, {CTRLDOWN}{v}{CTRLUP}
	return

^+P::
	RunWait, ruby "%RWIN_HOME%\fixwidth.rb"  -c-- -o clip, , Hide
	Send, {CTRLDOWN}{v}{CTRLUP}
	return

^!f::
	RunWait, ruby "%RWIN_HOME%\sqlstrfmt.rb", , Hide
	Send, {CTRLDOWN}{v}{CTRLUP}
	return

^-::	Send, (nolock)

^f1::	Send, sp_help {CTRLDOWN}{v}{CTRLUP}{SHIFT DOWN}{HOME}{SHIFT UP}{F5}

^f2::
	Send, sp_helptext {CTRLDOWN}{v}{CTRLUP}{SHIFT DOWN}{HOME}{SHIFT UP}{F5}
	loop 10 {
		WinWait, A, Executing, 0.5
		if errorlevel {
			Sleep, 100
			Send, {F6}{CTRLDOWN}a{CTRLUP}
			break
		}
	}
	return
	
#IfWinActive, SQL Server Management Studio
; clear SSMS filter
^r::
	Send, {Appskey}
	Sleep, 300
	; SSMS 2014 uses key 't'
	Send, tm
	return

; show SSMS filter window
^l::
	Send, {Appskey}
	Sleep, 300
	Send, ts
	WinWait, Filter Settings,
	IfWinNotActive, Filter Settings, , WinActivate, Filter Settings,
	WinWaitActive, Filter Settings,
	Send, {TAB}{TAB}
	return

; SSMS filter window
#IfWinActive, Filter Settings,

^ENTER::	MouseClick, left,  326,  415

#IfWinActive, Check In - Source Files - Workspace
^f::	MouseClick, left,  190,  48

; VS 2008 reporting designer expression windows
#IfWinActive, Expression,
^ENTER::
	ControlGetPos, x, y, , , OK
	MouseClick, , x+40, y+12, , 10
	return
