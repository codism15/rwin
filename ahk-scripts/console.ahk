#IfWinActive,

GroupAdd, window_with_path, ahk_class ExploreWClass
GroupAdd, window_with_path, ahk_class CabinetWClass

; get working folder
GetWorkingFolder() {
	if WinActive("ahk_class ExploreWClass") or WinActive("ahk_class CabinetWClass") {
		; windows 8
		ControlGetText, pathstr, ToolbarWindow323
		if StrLen(pathstr) = 0 {
			ControlGetText, pathstr, ToolbarWindow322
			if StrLen(pathstr) = 0 {
				ControlGetText, pathstr, Edit1				
			}
		} else {
			if InStr(pathstr, "Address: ") {
				pathstr := SubStr(pathstr, 10)
			}
			
			; windows 7 control panel
			if InStr(pathstr, ":") <> 2 {
				pathstr := "C:\"
			}
		}
		return %pathstr%
	} else {
		return "C:\"
	}
}

#c::
	pathstr := GetWorkingFolder()
	if PROCESSOR_ARCHITEW6432
	{
		Run, %ComSpec%, %pathstr%
	}
	else
	{
		Run, %ComSpec%, %pathstr%
	}
	if StrLen(pathstr) > 3
	{
		Run, "%RWIN_HOME%\scd_.exe" -a "%pathstr%", , Hide
	}
	return

#^c::
	Run, %ComSpec%, %temp%
	return
	
; irb
#!b::
	pathstr := GetWorkingFolder()
	Run, "%CYGWIN_HOME%\bin\ruby" /usr/bin/irb, %pathstr%
	return

; bash
#b::
	pathstr := GetWorkingFolder()
	Run, "%CYGWIN_HOME%\bin\bash" --login, %pathstr%
	return

; paste in consle
+INS::
	if WinActive("ahk_class ConsoleWindowClass") {
		WinGetPos, x, y, w, h, A
		MouseGetPos, mx, my
		;MsgBox x=%x% y=%y% w=%w% h=%h% mx=%mx% my=%my%
		if (mx < 10)
			mx = 10
		else if (mx > w - 30)
			mx := w - 30
		
		if (my < 40)
			my = 40
		else if (my > h)
			my := h - 10

		MouseClick, right, mx, my
	}
	return

#IfWinActive, ahk_group window_with_path

^+C::	clipboard := GetWorkingFolder()