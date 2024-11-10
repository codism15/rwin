SetMouseDelay, 20
SetDefaultMouseSpeed, 10

#IfWinActive, LEGO Education SPIKE

F5::
    WinGetPos, x, y, width, height, A
    MouseGetPos, mouseX, mouseY
    MouseClick, left, width - 80, height - 55,
    MouseMove, mouseX, mouseY, 5
    return
