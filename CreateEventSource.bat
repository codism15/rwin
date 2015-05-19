	@echo off
	setlocal
	
	eventcreate /ID 1 /L APPLICATION /T INFORMATION  /SO "%~1" /D "First log"