	@echo off
	@setlocal ENABLEDELAYEDEXPANSION

	FOR %%i IN (%*) DO (
		if exist "%%~i" (
			call:process "%%~i"
		)
	)

	goto:eof

:process
	rem echo %~1
	if "%~x1"==".bak" (
		echo SKIP %~1
		goto:eof
	)
	
	for /f "usebackq" %%i in (`sigcheck -q -n "%~1"`) do (
		set TS=%%i
	)
	
	if errorlevel 1 exit /b 1

	set DEST=%~f1.%TS%.bak
	
	rem echo DEST=!DEST!
	
	if exist "!DEST!" (
		echo SKIP %~1
	) else (
		echo %~1
		copy "%~1" "!DEST!"
	)
	goto:eof