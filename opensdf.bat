@echo off
setlocal

if "%~1"=="" (
	echo Missing sdf file name!
	goto:eof
)

::echo %1 | sed "s/[""]//g" | putclip

set AHK=%~dp0AutoHotkey
"%AHK%\AutoHotkey.exe" "%~dp0ahk-scripts\open-sdf.ahk" "%~1"
