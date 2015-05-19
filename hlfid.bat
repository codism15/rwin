::	create hardlink with fileid (NTFS only)
	@echo off
	setlocal ENABLEDELAYEDEXPANSION
	
	for %%i in (%*) do (
		call:getfileid "%%i"
		if not "!fileid!"=="" (
			set fn=__%%~ni-!fileid!%%~xi
			if not exist "!fn!" (
				fsutil hardlink create "!fn!" "%%~i"
			)
		)
	)
	
	goto:eof
	
:getfileid
	set fileid=
	for /f "usebackq" %%i in (`ntfs-fileid.exe "%~1"`) do (
		set fileid=%%i
	)
	goto:eof
