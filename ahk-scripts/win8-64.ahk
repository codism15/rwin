SetDefaultMouseSpeed, 6
SetTitleMatchMode, 2

#include common.ahi
#include console.ahk
#include move-window.ahk
#include devs.ahk

#IFWinActive,
;================temporary test ======================================
#+?::
	WinGet, pid, PID, A
	MsgBox %pid%
	return

MButton::	MouseClick, left, , ,2

#Esc::	Run, %UTILS_HOME%\procexp.exe

^PgDn::
	loop 4 {
		Send, {PgDn}
		Sleep, 300
	}
	Send, {PgDn}
	return
^PgUp::
	loop 4 {
		Send, {PgUp}
		Sleep, 300
	}
	Send, {PgUp}
	return
	
; start firefox
#w::
	Run, "%ProgramFiles%\Mozilla Firefox\firefox.exe"
	WaitAndActivate("Mozilla Firefox")
	return
	
#+W::
	Run, "C:\Program Files\Internet Explorer\iexplore.exe", "%HOMEDRIVE%%HOMEPATH%"
	return

#^w::	Run, chrome

#n::	Run, "%windir%\notepad.exe"
#+N::	Run, "C:\Program Files (x86)\Programmer's Notepad\pn.exe"
#^n::	Run, "C:\Program Files (x86)\Notepad++\notepad++.exe"

#p::	Send, {ALTDOWN}{PRINTSCREEN}{ALTUP}
#^p::	Run, "mspaint"
#!p::
	Send, {ALTDOWN}{PRINTSCREEN}{ALTUP}
	Run, "mspaint"
	return
#+P::	Run, "%ProgramFiles%\Paint.NET\PaintDotNet.exe"

#f6::	RUn, %RWIN_HOME%\MyIntelliSense\MyIntelliSense.exe, , Min
#f11::	Run "%RWIN_HOME%\AutoHotkey\AutoHotkey.chm"
#+f11::	Run explorer "%A_ScriptDir%"
#f12::	Run "%RWIN_HOME%\AutoHotkey\AutoScriptWriter\AutoScriptWriter.exe"
#+f12::	Run "%RWIN_HOME%\AutoHotkey\AU3_Spy.exe"

#o::	Run, "outlook"
#+O::	Run, "onenote"
#+E::	Run, "excel"

; delete crossmark links
#^f1::
	FileDelete, C:\Documents and Settings\rui.luo\Desktop\CROSSMARK IT Portal.url
	Run, net use r: /delete , , Hide
	return

+Space::
	loop, 3
	{
		Send, {Space}{Down}
	}
	return





#IfWinActive, Open Document
^o::
	ControlGetPos, x, y, w, h, Button1, A,
	if not x=""
		MouseClick, left,  x + 40,  y + 10
	return

#IfWinActive, - Microsoft Word
f11::	Send, {ALTDOWN}w{ALTUP}f

#IfWinActive, - Foxit Reader
!1::	Send, {ALTDOWN}v{ALTUP}ps
!2::	Send, {CTRLDOWN}2{CTRLUP}{ALTDOWN}v{ALTUP}pf

#IfWinActive, ahk_class #32770

;f7::
;	WinGet, dialog_id, ID, A
;	SetTitleMatchMode, RegEx
;	WinGet, ids, list, ahk_class ExploreWClass|CabinetWClass
;	loop %ids% {
;		this_id := % ids%A_Index%
;		ControlGetText, path, Edit1, ahk_id %this_id%
;		if instr(path, ":\") = 0
;			continue
;		Menu, mymenu, Add, %path%, p1
;		if (last_selected_path = path) {
;			Menu, mymenu, Default, %path%
;		}
;	}
;	ControlGetPos, x, y, w, h, Edit1, A
;	MouseMove, x, y+h, 4
;	Menu, mymenu, show
;	return

p1:
	last_selected_path := A_ThisMenuItem
	ControlSetText, Edit1, %A_ThisMenuItem%, ahk_id %dialog_id%
	return

; for beyond compare 2.4.1
#IfWinActive, ahk_class TFiltersDlg
^Enter::	MouseClick, left,  330,  395

; end of the global script, call the user script, if any
;#include C:\Documents and Settings\rui.luo\rc.ahk
