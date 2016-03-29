	@echo off
	setlocal
	
	set CLIPEXE=%~dp0rclip.exe
	
	for /f "usebackq" %%i in (`"%CLIPEXE%" ^| grep -E "^\s*(///|//|--)" -o`) do (
		set PREFIX=%%i
	)
	
	if "%PREFIX%"=="" (
		"%CLIPEXE%" | dos2unix | fmt -w 90 | unix2dos | "%CLIPEXE%" -i
	) else (
		"%CLIPEXE%" | dos2unix | fmt "-p%PREFIX%" -w 90 | unix2dos | "%CLIPEXE%" -i
	)
	
