#IfWinActive, ahk_class #32770

SetTitleMatchMode, RegEx

f7::
	WinGet, dialog_id, ID, A
	WinGet, ids, list, ahk_class ExploreWClass|CabinetWClass
	loop %ids% {
		this_id := % ids%A_Index%
		ControlGetText, path, Edit1, ahk_id %this_id%
		if instr(path, ":\") = 0
			continue
		Menu, mymenu, Add, %path%, p1
		if (last_selected_path = path) {
			Menu, mymenu, Default, %path%
		}
	}
	ControlGetPos, x, y, w, h, Edit1, A
	MouseMove, x, y+h, 4
	Menu, mymenu, show
	return

p1:
	last_selected_path := A_ThisMenuItem
	ControlSetText, Edit1, %A_ThisMenuItem%, ahk_id %dialog_id%
	return

^p::
	ControlGetPos, x, y, w, h, ComboBox3, A
	if ! x
		return
	MouseClick, , x+w-10, y+h-10, , 4
	Send, p
	Sleep, 500
	Send {ENTER}
	return
	
^[::	reload