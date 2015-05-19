	@echo off
	@setlocal ENABLEDELAYEDEXPANSION

	for /f "usebackq" %%i in (`"%~dp0getdatetime" -f yyyyMMddThh`) do (
		set TS=%%i
	)

	rem echo %TS%

	FOR %%i IN (%*) DO (
		call:process "%%~i"
	)

	goto:eof

:process
	rem echo %~1
	if "%~x1"==".bak" (
		echo SKIP %~1
		goto:eof
	)
	
	set DEST=%~f1.%TS%.bak
	
	rem echo DEST=!DEST!
	
	if exist "!DEST!" (
		echo SKIP %~1
	) else (
		echo %~1
		if exist "%~1\*" (
			xcopy /E "%~1" "!DEST!\"
		) else (
			copy "%~1" "!DEST!" > nul
		)
	)
	goto:eof