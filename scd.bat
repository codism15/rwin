	@echo off

	if "%~1"=="" ( dir /ad && goto:eof )

	:loop

	if exist "%~1" ( cd "%~1" && goto:next )
	for /d %%i in ("*%~1*") do ( cd "%%~i"	&& goto:next)
	
	goto:eof

	:next

	shift
	if not "%~1"=="" goto:loop
