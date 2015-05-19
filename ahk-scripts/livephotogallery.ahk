;#include mouse.ahi

#IfWinActive

SetTitleMatchMode, 2

activate_tag_box() {
	WinGetPos, , , w, h, A
	coordmode, pixel, relative
	coordmode, mouse, relative
	ImageSearch, x, y, w-300, 100, w, 300, *15 live-photo-gallery-add-tag.png
	if errorlevel
	{
		Send, {ALTDOWN}i{ALTUP}
		Sleep, 300
		ImageSearch, x, y, w-300, 100, w, 300, *15 live-photo-gallery-add-tag.png
		if errorlevel
			return
	}
	MouseMove, x+10, y+8
	MouseClick, left
	Sleep, 100
}

drag_viewbox(dir) {
	;save_mouse_current_pos()
	WinGetPos, , , w, h, A
	x1 := w / 4
	x2 := w * 3 / 4
	y1 := h / 4
	y2 := h * 3 / 4
	CoordMode, Mouse, Relative

	if (dir = "up") {
		MouseClickDrag, left, x1, y1, x1, y2, 1, 
	} else if (dir = "down") {
		MouseClickDrag, left, x1, y2, x1, y1, 1, 
	} else if (dir = "left") {
		MouseClickDrag, left, x1, y1, x2, y1, 1, 
	} else if (dir = "right") {
		MouseClickDrag, left, x2, y1, x1, y1, 1, 
	}
	;restore_mouse_pos()
}

drag_crop_handle(dir, handle_name="area") {
	WinGetPos, , , w, h, A
	coordmode, pixel, relative
	coordmode, mouse, relative
	ImageSearch, x, y, 50, 60, w-200, h-100, images\live-photog-crop-handle.png
	if errorlevel
		return 0

	x0 := x
	y0 := y
	
	offset := 20
	
	if (handle_name != "area")
		offset := 3

	if (handle_name = "top" or handle_name = "bottom" or instr(handle_name, "right")) {
		ImageSearch, x1, , x0+8, y0, w-200, y0+8, images\live-photog-crop-handle.png

		if errorlevel
			return 0

		if instr(handle_name, "right")
			x := x1+x1-x0+1
		else
			x := x1
	}
	if (handle_name = "left" or handle_name = "right" or instr(handle_name, "bottom")) {
		ImageSearch, , y1, x0, y0+8, x0+8, h-100, images\live-photog-crop-handle.png

		if errorlevel
			return 0
		
		if instr(handle_name, "bottom")
			y := y1+y1-y0+1
		else
			y := y1
	}

	xstep := 0
	ystep := 0
	if instr(dir, "up")
		ystep := -100
	else if instr(dir, "down")
		ystep := +100
	
	if instr(dir, "left")
		xstep := -100
	else if instr(dir, "right")
		xstep := +100
	
	MouseClickDrag, left, x+offset, y+offset, x+offset+xstep, y+offset+ystep, 1
}

add_tag(tg) {
	save_mouse_current_pos()
	activate_tag_box()
	if errorlevel
	{
		MsgBox Didn't detect add tag button
		return
	}
	if tg
		Send, %tg%{ENTER}
	restore_mouse_pos()
}

#IfWinActive, Windows Live Photo Gallery
^t::	add_tag("")

#IfWinActive, - Windows Live Photo Gallery

; prefix keys
q::	Send, q
w::	send, w
e::	Send, e
a:: send, a
d::	send, d
z:: send, z
x::	send, x
c::	send, c

/::	Send, {CTRLDOWN}0{CTRLUP}
\::	Send, {CTRLDOWN}0{CTRLUP}
0::	Send, {CTRLDOWN}0{CTRLUP}
1::	Send, {CTRLDOWN}0{CTRLUP}
f1::	Send, {CTRLDOWN}0{CTRLUP}

PGUP::	Send, {LEFT}
PGDN::	Send, {RIGHT}

UP::
	drag_crop_handle("up")
	if errorlevel
		drag_viewbox("up")
	return

DOWN::
	drag_crop_handle("down")
	if errorlevel
		drag_viewbox("down")
	return

LEFT::
	drag_crop_handle("left")
	if errorlevel
		drag_viewbox("left")
	return

RIGHT::
	drag_crop_handle("right")
	if errorlevel
		drag_viewbox("right")
	return

q & LEFT::		drag_crop_handle("left", "left-top")
q & RIGHT::		drag_crop_handle("right", "left-top")
q & UP::		drag_crop_handle("up", "left-top")
q & DOWN::		drag_crop_handle("down", "left-top")

w & UP::		drag_crop_handle("up", "top")
w & DOWN::		drag_crop_handle("down", "top")

e & LEFT::		drag_crop_handle("left", "right-top")
e & RIGHT::		drag_crop_handle("right", "right-top")
e & UP::		drag_crop_handle("up", "right-top")
e & DOWN::		drag_crop_handle("down", "right-top")

a & LEFT::		drag_crop_handle("left", "left")
a & RIGHT::		drag_crop_handle("right", "left")

d & LEFT::		drag_crop_handle("left", "right")
d & RIGHT::		drag_crop_handle("right", "right")

z & LEFT::		drag_crop_handle("left", "left-bottom")
z & RIGHT::		drag_crop_handle("right", "left-bottom")
z & UP::		drag_crop_handle("up", "left-bottom")
z & DOWN::		drag_crop_handle("down", "left-bottom")

x & UP::		drag_crop_handle("up", "bottom")
x & DOWN::		drag_crop_handle("down", "bottom")

c & LEFT::		drag_crop_handle("left", "right-bottom")
c & RIGHT::		drag_crop_handle("right", "right-bottom")
c & UP::		drag_crop_handle("up", "right-bottom")
c & DOWN::		drag_crop_handle("down", "right-bottom")

!x::	Send, {ALTDOWN}x{ALTUP}

; button shortcuts

; apply button
^a::
	WinGetPos, , , w, h, A
	coordmode, pixel, relative
	coordmode, mouse, relative
	ImageSearch, x, y, w-300, 250, w, 400, *15 live-photo-gallery-btnApply.png
	if errorlevel
	{
		MsgBox, Not detect apply button
	}
	else
	{
		MouseClick, , x+20, y+8, , 8
	}
	return
