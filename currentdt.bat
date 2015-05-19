:: set current date time in enviroment variable in a compact string
	@echo off
	
	for /f "tokens=1-3 delims=/ " %%A in ("%DATE%") DO (
		set DATESTR=%%C%%A%%B
	)
	
	for /f "tokens=1-3 delims=:." %%F in ("%TIME%") DO (
		set TIMESTR=%%F%%G%%H
	)
	
	set CURRENTDT=%DATESTR%T%TIMESTR%
