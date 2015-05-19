	@echo off
	@setlocal
	
	set FILTER=%~1
	
	if not defined FILTER (
		echo usage: scd-remove-non-exist.bat FILTER
		exit /b 1
	)
	
	pushd "%temp%"
	
	scd_.exe -d ^
		| sed -e "/-- dirs/,/-- keys/!d" ^
		| cut -f 2 ^
		| dos2unix ^
		| findstr /C:"%FILTER%" > scd-dirs.tmp
	
	for /f %%i in (scd-dirs.tmp) do (
		if not exist "%%i" (
			echo Deleting %%i from scd db...
			scd_ --deletepath "%%i"
		)
	)
	
	del scd-dirs.tmp
