sdf=%1%

if strlen(sdf)=0 {
	msgbox, missing sdf filename
	exit
}

SetDefaultMouseSpeed, 4

Run, ssms, %CD%

WinWait, Connect to Server, 
IfWinNotActive, Connect to Server, , WinActivate, Connect to Server, 
WinWaitActive, Connect to Server, 

MouseClick, left,  392,  111
Sleep, 100

MouseClick, left,  376,  165
Sleep, 100

ControlSetText, Edit1, %sdf%

Sleep, 100

MouseClick, left,  115,  283

exit