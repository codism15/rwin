	@echo off

	if "%~1"=="-" cd "%SCD_BACK%" && goto:eof

	if "%~1"=="" (
		call:dircache_ext ""
		goto:eof
	)
	
	if "%~1"=="/?" (
		%~dp0\scd_.exe -?
		goto:eof
	)

	if "%~1"=="~" (
		set "SCD_DEST=%USERPROFILE%"
	) else (
		set "SCD_DEST=%~1"
	)
	
	set SCD_BACK=%CD%
	
	if "%SCD_DEST%"=="\" cd \ && goto:eof
	if "%SCD_DEST%"=="/" cd \ && goto:eof
	if "%SCD_DEST%"==".." cd .. && goto:eof
	if "%SCD_DEST%"=="..." cd ..\.. && goto:eof
	if "%SCD_DEST%"=="...." cd ..\..\.. && goto:eof
	if "%SCD_DEST%"=="....." cd ..\..\..\.. && goto:eof

	if exist "%SCD_DEST%" cd "%SCD_DEST%" && goto:dir_changed

	call:dircache_ext %*
	goto:eof

:dir_changed
	%~dp0\cdhist.exe -a "%CD%"
	goto:eof

:dircache_ext
	%~dp0\cdhist.exe -o "%TEMP%\scd.tmp" %*
	
	if errorlevel 1 goto:eof
	
	for /f "usebackq delims=" %%i in ("%TEMP%\scd.tmp") do (
		set "SCD_BACK=%CD%"
		cd "%%i"
		goto:eof
	)