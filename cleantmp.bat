	@echo off
	cd "%temp%"
	if errorlevel 1 (
		echo cannot switch to the temp folder
		goto:eof
	)
	
	rmdir /s /q .