SetKeyDelay, 50

^f12::
Send, %clipboard%
return

#IfWinActive, Text Import Wizard - Step 1 of 3, 

^i::

;next
Send, {ALTDOWN}n{ALTUP}

Sleep, 300

;next
Send, {ALTDOWN}n{ALTUP}

Sleep, 300

Loop, 15
{
	MouseClick, left, 520, 346
	Sleep, 50
}

Send, {SHIFTDOWN}
MouseClick, left, 520, 300
Send, {SHIFTUP}
Sleep, 200

; select text format
Send, {ALTDOWN}t{ALTUP}
Sleep, 200

Send, {ALTDOWN}f{ALTUP}
Sleep, 500

Send, {ENTER}
Sleep, 300

; replace NULL
Send, {CTRLDOWN}h{CTRLUP}
WinWait, Find and Replace, 
IfWinNotActive, Find and Replace, , WinActivate, Find and Replace, 
WinWaitActive, Find and Replace, 
Send, {ALTDOWN}n{ALTUP}{SHIFTDOWN}null{SHIFTUP}{TAB}{ALTDOWN}a{ALTUP}
Sleep, 100
Send, {ENTER}{ESC}

return