#include common.ahi

WaitAndActivate(title) {
	WinWait, %title%,
	IfWinNotActive, %title%, , WinActivate, %title%,
	WinWaitActive, %title%,
	Sleep, 100
}

; returns the monitor number that continas (x,y), or zero if the point is
; outside of any monitor

GetMonitorByPos(x, y, byref left=0, byref right=0, byref top=0, byref bottom=0) {

	SysGet, MonitorCount, MonitorCount
	
	Loop, %MonitorCount% {
		SysGet, wa, MonitorWorkArea, %A_Index%

		if (x >= waLeft && x <= waRight && y >= waTop && y <= waBottom) {
			left := waLeft
			right := waRight
			top := waTop
			bottom := waBottom
			return %A_Index%
		}
	}
	
	return 0
}

; move the current window
MoveWindow(direction = "left", handler = 0) {

	; get current window
	cid := WinExist("A")

	if (cid = 0) {
		MsgBox Cannot get the current window
		return 0
	}

	; set window size to normal if it is maximized
	WinGet, mm, MinMax, ahk_id %cid%
	if mm = 1
		WinRestore, ahk_id %cid%

	WinGetPos, x, y, width, height, ahk_id %cid%, , ,

	x_center := x + width / 2
	y_center := y + height / 2
	
	;MsgBox current x=%x% y=%y%
	
	; get screen working area
	
	activeMonitor := GetMonitorByPos(x_center, y_center, waLeft, waRight, waTop, waBottom)
	
	if (!activeMonitor) {
		MsgBox Cannot get screen working area
		return 0
	}
	
	; prepare searching conditions
	
	minWinHeight := 150
	minWinWidth := 150
	
	if (direction = "up") {
		if (handler = 0) {
			start := y
			end := waTop
		} else if (handler = 12) {
			start := y
			end := waTop
		} else if (handler = 6) {
			start := y + height
			end :=  y + minWinHeight
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "down") {
		if (handler = 0) {
			start := y
			end := waBottom - height
		} else if (handler = 12) {
			start := y
			end := y + height - minWinHeight
		} else if (handler = 6) {
			start := y+height
			end := waBottom
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "left") {
		if (handler = 0 or handler = 9) {
			start := x
			end := waLeft
		} else if (handler = 3) {
			start := x + width
			end := x + minWinWidth
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "right") {
		if (handler = 0) {
			start := x
			end := waRight - width
		} else if (handler = 9) {
			start := x
			end := waRight - minWinWidth
		} else if (handler = 3) {
			start := x + width
			end := waRight
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else {
		MsgBox Unhandled direction %direction%
		return 0
	}

	nextPos := end
	delta := end - start

	;MsgBox start=%start% end=%end% nextPos=%nextPos%
	
	; loop through windows in the current monitor
	WinGet, ids, list

	loop %ids% {
	
		this_id := % ids%A_Index%

		if (this_id = cid)
			continue
		
		; skip maximized windows
		WinGet, mm, MinMax, ahk_id %this_id%
		if mm = 1
			continue

		WinGetTitle, Title, ahk_id %this_id%,,Program Manager,
		if (StrLen(Title) = 0)
			continue
			
		WinGetPos, this_x, this_y, this_width, this_height, ahk_id %this_id%
		
		if this_x=
			continue
		
		; skip windows in the other screen
		if (this_x < waLeft || this_x > waRight || this_y < waTop || this_y > waBottom)
			continue

		;MsgBox test with %Title% x=%this_x% y=%this_y%
		
		if (direction = "left" or direction = "right") {
			GetNextValue(start, end, this_x, nextPos, delta)
			GetNextValue(start, end, this_x + this_width, nextPos, delta)
			if (handler = 0) {
				GetNextValue(start, end, this_x - width, nextPos, delta)
				GetNextValue(start, end, this_x + this_width - width, nextPos, delta)
			}
		} else {
			GetNextValue(start, end, this_y, nextPos, delta)
			GetNextValue(start, end, this_y + this_height, nextPos, delta)
			if (handler = 0) {
				GetNextValue(start, end, this_y - height, nextPos, delta)
				GetNextValue(start, end, this_y + this_height - height, nextPos, delta)
			}
		}
	}
	
	;MsgBox nextPos=%nextPos% delta=%delta%
	
	if (direction = "up") {
		if (handler = 0) {
			y := nextPos
		} else if (handler = 12) {
			y := nextPos
			height -= delta
		} else if (handler = 6) {
			height += delta
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "down") {
		if (handler = 0) {
			y := nextPos
		} else if (handler = 12) {
			y := nextPos
			height -= delta
		} else if (handler = 6) {
			height += delta
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "left") {
		if (handler = 0) {
			if (x = nextPos and nextPos = waLeft) {
				newMonitor := GetMonitorByPos(waLeft-width, y_center)
				if (newMonitor) {
					x := waLeft-width
				}
			} else {
				x := nextPos
			}
		} else if (handler = 9) {
			x := nextPos
			width -= delta
		} else if (handler = 3) {
			width += delta
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else if (direction = "right") {
		if (handler = 0) {
			if (x = nextPos && x + width == waRight) {
				newMonitor := GetMonitorByPos(waRight+1, y_center)
				if (newMonitor) {
					x := waRight
				}
			} else {
				x := nextPos
			}
		} else if (handler = 9) {
			x := nextPos
			width -= delta
		} else if (handler = 3) {
			width += delta
		} else {
			MsgBox Unhandled handler %handler% for %direction%
			return 0
		}
	} else {
		MsgBox Unhandled direction %direction%
		return 0
	}
	
	WinMove, ahk_id %cid%, ,x, y, width, height
}

; duck current window

DuckWindow(direction = "left") {

	; get current window
	cid := WinExist("A")

	if (cid = 0) {
		MsgBox Cannot get the current window
		return 0
	}

	; set window size to normal if it is maximized
	WinGet, mm, MinMax, ahk_id %cid%
	if mm = 1
		WinRestore, ahk_id %cid%

	WinGetPos, x, y, width, height, ahk_id %cid%, , ,

	x_center := x + width / 2
	y_center := y + height / 2

	;MsgBox current x=%x% y=%y%
	
	; get screen working area
	
	activeMonitor := GetMonitorByPos(x_center, y_center, waLeft, waRight, waTop, waBottom)
	
	if (!activeMonitor) {
		MsgBox Cannot get screen working area
		return 0
	}
	
	if (direction = "left") {
		width := (waRight - waLeft) / 2
		height := waBottom - waTop
		x := waLeft
		y := waTop
	} else if (direction = "right") {
		width := (waRight - waLeft) / 2
		height := waBottom - waTop
		x := waLeft + width
		y := waTop
	} else if (direction = "top") {
		width := waRight - waLeft
		height := (waBottom - waTop) / 2
		x := waLeft
		y := waTop
	} else if (direction = "bottom") {
		width := waRight - waLeft
		height := (waBottom - waTop) / 2
		x := waLeft
		y := waTop + height
	}
	
	WinMove, ahk_id %cid%, ,x, y, width, height
}

#IfWinActive,

#LEFT::		MoveWindow("left", 0)
#RIGHT::	MoveWindow("right", 0)
#UP::		MoveWindow("up", 0)
#Down::		MoveWindow("down",0)

#+LEFT::	MoveWindow("left", 9)
#+RIGHT::	MoveWindow("right", 9)
#+UP::		MoveWindow("up", 12)
#+Down::	MoveWindow("down",12)
	
#!LEFT::	MoveWindow("left", 3)
#!RIGHT::	MoveWindow("right", 3)
#!UP::		MoveWindow("up", 6)
#!Down::	MoveWindow("down",6)
	
#^LEFT::	DuckWindow("left")
#^RIGHT::	DuckWindow("right")
#^UP::		DuckWindow("top")
#^DOWN::	DuckWindow("bottom")
#HOME::		WinMove, A, , 0, 0

!f9::
	cid := WinExist("A")
	if (cid = 0)
		return
	WinGet, mm, MinMax, ahk_id %cid%
	if mm = -1
		WinRestore, ahk_id %cid%
	else
		WinMinimize, ahk_id %cid%
	return

!f10::
	cid := WinExist("A")
	if (cid = 0)
		return
	WinGet, mm, MinMax, ahk_id %cid%
	if mm = 1
		WinRestore, ahk_id %cid%
	else
		WinMaximize, ahk_id %cid%
	return
