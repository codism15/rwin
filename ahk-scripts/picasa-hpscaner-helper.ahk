SetDefaultMouseSpeed, 6

#IfWinActive, Picasa 3,
^s::
MouseClick, left,  106,  66
Sleep, 1000

MouseClick, left,  143,  133
Sleep, 800

MouseClick, left,  134,  179
Sleep, 5000

WinWait, hp scanning,

IfWinNotActive, hp scanning, , WinActivate, hp scanning,
WinWaitActive, hp scanning,

; wait preview scan
Sleep, 13000

; in hp-scanner
; load scan profile
MouseClick, left,  77,  57
Sleep, 1000
MouseClick, left,  97,  166
Sleep, 800
MouseMove, 219, 166
Sleep, 300
MouseClick, left,  219,  186
Sleep, 1500

WinWait, Load Profile -- Web Page Dialog, 
IfWinNotActive, Load Profile -- Web Page Dialog, , WinActivate, Load Profile -- Web Page Dialog, 
WinWaitActive, Load Profile -- Web Page Dialog, 

MouseClick, left,  316,  59
Sleep, 800
MouseClick, left,  318,  94
Sleep, 800
MouseClick, left,  170,  312
Sleep, 5000

WinWait, hp scanning, 
IfWinNotActive, hp scanning, , WinActivate, hp scanning, 
WinWaitActive, hp scanning, 

; accept
MouseClick, left,  455,  481
Sleep, 40000

WinWait, Picasa 3, 
IfWinNotActive, Picasa 3, , WinActivate, Picasa 3, 
WinWaitActive, Picasa 3, 

; import
MouseClick, left,  423,  811
Sleep, 1000

WinWait, Finish Importing, 
IfWinNotActive, Finish Importing, , WinActivate, Finish Importing, 
WinWaitActive, Finish Importing, 

Sleep, 1000
; select a previous folder

MouseClick, left,  488,  139
Sleep, 900
MouseClick, left,  488,  170
Sleep, 700
MouseClick, left,  495,  496
Sleep, 1000

return