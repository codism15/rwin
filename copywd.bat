	@echo off
	setlocal ENABLEDELAYEDEXPANSION
	
	if "%1"=="" (
		echo Usage: copywidthdate a:*.sdf .
		exit /b 1
	)
	
	set DEST=.
	
	if not "%2"=="" (
		set DEST=%~2
	)
	
	for %%i in (%1) do (
		call:getdatestr "%%~i"
		set DESTFILE=%DEST%\!DATESTR!-%%~ni%%~xi
		if exist "!DESTFILE!" (
			echo SKIP %%~i
		) else (
			echo COPY %%~i
			copy "%%~i" "!DESTFILE!" > nul
		)
	)
	
	goto:eof
	
:getdatestr
	for /f "usebackq" %%a in (`getdatetime -f yyMMddTHHmm "%~t1"`) do (
		set DATESTR=%%a
	)
	goto:eof