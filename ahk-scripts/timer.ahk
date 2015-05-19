#IfWinActive,

simple_timer(timer_name, ms) {
	Run, msg.exe * /time:5 %timer_name% timer started. This message box will be automatically dismissed, , Min,
	Sleep, %ms%
	Run, msg.exe * %timer_name% timer ended at %A_Hour%:%A_Min%, , Min,
}

#t::	simple_timer("1 minute", 60000)
#+T::	simple_timer("3 Minutes", 180000)
#^t::	simple_timer("5 Minutes", 300000)
#!t::	simple_timer("10 Minutes", 600000)
