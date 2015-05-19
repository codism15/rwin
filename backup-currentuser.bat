	@echo off
	@setlocal
	
	if "%~1"=="" (
		echo The first command line argument must be the destination directory
		exit /b 1
	)
	
	set backdir=%~1
	shift
	
	set stubfile=%USERNAME%@%COMPUTERNAME%.txt
	if not exist "%backdir%\%stubfile%" (
		echo Stub file does not exist: %backdir%\%stubfile%
		exit /b 1
	)
	
	set OPTIONS=/r:0 /w:10 /np /ns /ndl /njs /njh
	set OPTIONS=%OPTIONS% /xf Thumbs.db *.ncb archive.pst outlook.ost "%stubfile%"
	set OPTIONS=%OPTIONS% /xd bin obj Debug	
	
	robocopy "%USERPROFILE%\Desktop" "%backdir%\Desktop" %OPTIONS% /mir
	robocopy "%USERPROFILE%\Favorites" "%backdir%\Favorites" %OPTIONS% /mir
	if exist "%USERPROFILE%\Documents\*" (
		REM Windows 7
		robocopy "%USERPROFILE%\Documents" "%backdir%\Documents" %OPTIONS% /mir
	) else (
		REM Windows XP
		robocopy "%USERPROFILE%\My Documents" "%backdir%\My Documents" %OPTIONS% /mir
	)
	set HOME_FILES=*.des3 .hgrc .vimrc scd.db
	robocopy "%USERPROFILE%" "%backdir%\home" %HOME_FILES% %OPTIONS% ^
		/xd local "Application Data" Favorites "My Documents" VirtualBox "Bluetooth Software" ^
		.trashcan.myrm Desktop "Start Menu" windows
	
:loop
	if "%~1"=="" goto:eof
	if not exist "%~1\*" (
		echo Invalid directory: %~1
		exit /b 1
	)
	robocopy "%~1" "%backdir%\%~n1" %OPTIONS% /mir
	shift
	goto:loop
