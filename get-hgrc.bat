	@echo off
	setlocal
	
	if "%~1"=="" (
		echo usage: get-hgrc.bat foldername
		exit /b 1
	)
	
	if exist hgrc (
		echo existing hgrc is found; aborted!
		exit /b 1
	)
	sed -e "s/rwin/%~1/" "%~dp0\.hg\hgrc" > hgrc