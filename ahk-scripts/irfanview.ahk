SetTitleMatchMode, 2

#IfWinActive, - IrfanView

^+I::	Send, ^i^{TAB}

#IfWinActive, IrfanView - IPTC

^ENTER::	Send  {ALTDOWN}w{ALTUP}
