	@echo off
	setlocal
	
	set RCOPY=c:\utils\robocopy.exe
	
	if not exist "%RCOPY%" (
		echo this script uses the robocopy at %RCOPY%
	)
	
	if "%~1"=="" (
		echo The first command line argument must be the destination directory
		exit /b 1
	)
	
	set backdir=%~1
	
	shift
	
	set stubfile=@%COMPUTERNAME%.txt
	if not exist "%backdir%\%stubfile%" (
		echo Stub file does not exist: %backdir%\%stubfile%
		exit /b 1
	)
	
	set OPTIONS=/r:1 /np /ns /ndl /njh /mir
	set OPTIONS=%OPTIONS% /xf Thumbs.db .picasa.ini *.ncb
	set OPTIONS=%OPTIONS% /xd bin obj
	
:loop
	if "%~1"=="" goto:eof
	if not exist "%~1\*" (
		echo Invalid directory: %~1
		exit /b 1
	)
	"%RCOPY%" "%~1" "%backdir%\%~n1" %OPTIONS%
	
	if errorlevel 1 exit /b 1
	
	shift
	goto:loop
