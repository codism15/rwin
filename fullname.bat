	@echo off
	setlocal

:lop

	if "%~1"=="" goto:eof
	
	for %%i in ("%~1") do call :printname %%i
	
	shift
	
	goto :lop

:printname
	echo %~dpnx1
