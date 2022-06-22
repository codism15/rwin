	@echo off

	if "%~1"=="" ( dir /ad && goto:eof )

	if "%~1" == "~" ( pushd "%USERPROFILE%" && goto:eof )

	if "%~1" == "-" ( popd && goto:eof )

	if "%~1" == "..." ( pushd "..\.." && goto:eof )

	if "%~1" == "...." ( pushd "..\..\.." && goto:eof )

:loop

	if exist "%~1" ( pushd "%~1" && goto:next )

	for /d %%i in ("*%~1*") do ( pushd "%%~i" && goto:next)
	
	goto:eof

:next

	shift
	if not "%~1"=="" goto:loop
