SetTitleMatchMode, 2
SetKeyDelay, 20

LoopCount=1

#IfWinActive, tblAuditStoreItem:

myret()
{
	global LoopCount
	Loop %LoopCount%
	{
		Send, {SHIFTDOWN}{TAB}{SHIFTUP}
	}
	Send, {DOWN}
}

; random numbers

f1::
Loop %LoopCount%
{
	Send, NULL{TAB}
	Sleep, 100
}
myret()
return

f2::
Loop %LoopCount%
{
	random, rand, 51, 100
	Send, %rand%{TAB}
	Sleep, 100
}
myret()
return

f3::
loop %LoopCount%
{
	Send, ^c
	ClipWait
	random, rand, 1, 50
	clipboard:=rand + clipboard
	Send, ^v
	Sleep, 50
	Send, {TAB}
	Sleep, 100
}
myret()
return

f4::
loop %LoopCount%
{
	Send, ^c
	ClipWait
	random, rand, 1, 50
	clipboard:=clipboard-rand
	Send, ^v
	Sleep, 50
	Send, {TAB}
	Sleep, 100
}
myret()
return

f10::
Loop %LoopCount%
{
	Send, 0{TAB}
}
myret()
return

f11::
Loop %LoopCount%
{
	Send, 1{TAB}
}
myret()
return

^t::
Loop %LoopCount%
{
	Send, True{TAB}
	Sleep, 100
}
myret()
return

^f::
Loop %LoopCount%
{
	Send, False{TAB}
	Sleep, 100
}
myret()
return

^ENTER::
myret()
return

^RIGHT::
Loop %LoopCount%
{
	Send, {TAB}
}
return

^1::
LoopCount=1
return

^2::
LoopCount=2
return

^3::
LoopCount=3
return

^4::
LoopCount=4
return

^5::
LoopCount=5
return

^6::
LoopCount=6
return

^7::
LoopCount=7
return

^8::
LoopCount=11
MsgBox Set LoopCount to 11
return

^9::
LoopCount=17
MsgBox Set LoopCount to 17
return
