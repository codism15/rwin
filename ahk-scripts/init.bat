	@echo off
	@setlocal
	
	REM setup ahk file association with autohotkey executable
	REM this batch only needs to run once per installation as 
	REM a initial setup
	
	assoc .ahk ahk_auto_file
	set AHK=..\AutoHotkey\AutoHotkey.exe
	call :setup1 "%AHK%"
	exit /b

:setup1
	ftype ahk_auto_file="%~dpnx1" "%%1"
	exit /b