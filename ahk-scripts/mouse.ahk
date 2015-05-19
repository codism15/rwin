#IfWinActive,

get_mouse_move_pixels() {
	GetKeyState, state, Shift
	if state = D
		return 100
	
	GetKeyState, state, Alt
	if state = D
		return 15
		
	GetKeyState, state, Ctrl
	if state = D
		return 300

	return 1
}

CapsLock & Down::
	p := get_mouse_move_pixels()
	MouseMove, 0, %p%, 1, R
	return

CapsLock & Up::
	p := get_mouse_move_pixels()
	MouseMove, 0, -%p%, 1, R
	return

CapsLock & Left::
	p := get_mouse_move_pixels()
	MouseMove, -%p%, 0, 1, R
	return

CapsLock & Right::
	p := get_mouse_move_pixels()
	MouseMove, %p%, 0, 1, R
	return
