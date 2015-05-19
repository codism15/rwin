#IfWinActive,

;=== activate the "safely remove hardware
remove_hardware() {
	coordmode, mouse, screen
	MouseGetPos, mouseX, mouseY
	coordmode, pixel, screen
	WinGetPos, trayX, trayY, trayWidth, trayHeight, ahk_class Shell_TrayWnd
	ImageSearch, imageX, imageY, trayX, trayY, trayX+trayWidth, trayY+trayHeight, *15 %A_ScriptDir%\images\safely-remove-hdwr.png
	if errorlevel
	{
		MsgBox Didn't detect the icon
		return
	}
	MouseMove, imageX+8, imageY+8
	MouseClick, left
	Sleep, 100
	MouseMove, %mouseX%, %mouseY%
}

; === safely remove the first one from bottom
remove_hardware_first() {
	coordmode, mouse, screen
	MouseGetPos, mouseX, mouseY
	coordmode, pixel, screen
	WinGetPos, trayX, trayY, trayWidth, trayHeight, ahk_class Shell_TrayWnd
	ImageSearch, imageX, imageY, trayX, trayY, trayX+trayWidth, trayY+trayHeight, *15 %A_ScriptDir%\images\safely-remove-hdwr.png
	if errorlevel
	{
		MsgBox Didn't detect the icon
		return
	}
	MouseMove, imageX+8, imageY+8
	MouseClick, left
	Sleep, 900
	MouseMove, -20, -15, ,R
	Sleep, 100
	MouseClick, left
	Sleep, 200
	MouseMove, %mouseX%, %mouseY%
}

expand_tray_area() {
	coordmode, mouse, screen
	coordmode, pixel, screen
	WinGetPos, trayX, trayY, trayWidth, trayHeight, ahk_class Shell_TrayWnd
	ImageSearch, imageX, imageY, trayX, trayY, trayX+trayWidth, trayY+trayHeight, *15 expand-tray.png
	if errorlevel
	{
		MsgBox Didn't detect the icon
		return
	}
	MouseMove, imageX+8, imageY+8
	MouseClick, left
}

#f10::	remove_hardware()
#+f10::	remove_hardware_first()
#f9::	expand_tray_area()
