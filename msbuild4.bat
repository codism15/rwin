	@echo off
	@setlocal ENABLEDELAYEDEXPANSION

	set SOLUTION=%~1
	
	if "%SOLUTION%"=="" @(
		for %%i in (*.sln) do @set SOLUTION=%%i
		echo Use solution !SOLUTION!
	)
	
	set BUILDER=C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
	
	"%BUILDER%" %SOLUTION% ^
		/p:Configuration=Release ^
		/p:WarningLevel=0 ^
		/nologo ^
		/verbosity:quiet
	
	if errorlevel 1 (
		echo error during build solution
		exit /b 1
	)
	
	for /d %%d in (*) do @(
		if exist "%%d\bin\Release\*.exe" @(
			pushd "%%d\bin\Release"
			make -f %RWIN_HOME%\makefiles\ilmerge-fx4-bin.make
			popd
		)
	)
