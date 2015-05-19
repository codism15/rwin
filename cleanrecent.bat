:: Clean XP recent document list except selected file types

	@echo off
	setlocal
	
	if not "%OS%"=="Windows_NT" (
		echo Does not support current OS
		exit /b 1
	)
	
	if "%USERPROFILE%"=="" (
		echo Cannot locate user root folder
		exit /b 1
	)
	
	call:changedrive "%USERPROFILE%"
	
	cd "%USERPROFILE%\Recent"
	
	del *.avi.lnk *.jpg.lnk *.dll.lnk *.png.lnk *.bsh.lnk *.ahk.lnk ^
		*.itest.lnk *.log.lnk *.sdf.lnk *.cab.lnk *.zip.lnk *.rb.lnk *.lst.lnk ^
		*.flv.lnk *.xml.lnk *.rar.lnk *.mp?.lnk *.mkv.lnk *.srt.lnk *.mov.lnk ^
		*.ltd.lnk *.ape.lnk *.cda.lnk *.csproj.lnk *.sln.lnk *.ini.lnk vts_*.lnk ^
		*.eqlog.lnk *.ps1.lnk *.sql*.lnk *.rm*.lnk *.3gp.lnk act.lnk utils.lnk ^
		*.wmv.lnk *.pbm.lnk *.tif.lnk

	c:\cygwin\bin\find.exe  -ctime +4 -print0 | xargs -0 -r -n 100 rm

	goto:eof
	
:changedrive
	%~d1
	goto:eof