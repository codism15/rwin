	@echo off
	@setlocal

	REM this script tests if two NTFS files are hardlinked

	@set f1=%~1
	@set f2=%~2
	@set exp=%~3
	
	@call:getfileid "%f1%"
	@set f1id=%FILEID%
	
	@call:getfileid "%f2%"
	@set f2id=%FILEID%
	
	if "%f1id%"=="%f2id%" (
		if "%exp%"=="0" (
			exit /b 0
		) else (
			if "%exp%"=="1" (
				echo %f1% and %f2% are expected to be two different files
				exit /b 1
			)
		)
	) else (
		if "%exp%"=="0" (
			echo %f1% and %f2% are expected to be hardlinked
			exit /b 1
		) else (
			if "%exp%"=="1" exit /b 0
		)
	)
	
	echo %f1%: %f1id%
	echo %f2%: %f2id%
	
	exit /b
	
:getfileid
	@set file=%~1
	for /f "usebackq" %%i in (`ntfs-fileid "%file%"`) do set FILEID=%%i
	if errorlevel 1 exit /b 1
	@goto:eof