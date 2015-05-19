	@echo off
	setlocal
	
	set SOLUTION=
	for %%i in (*.sln) do (
		set SOLUTION=%%i
	)
	
	if "%SOLUTION%"=="" (
		echo cannot find solution file
		exit /b 1
	)
	
	set BUILD_NUMBER=
	set R_NUMBER=%RANDOM%
	
	for /f "usebackq" %%i in (`getdatetime.exe -f yyMMdd`) do (
		set BUILD_NUMBER=%%i
	)
	
	if "%BUILD_NUMBER%"=="" (
		echo Cannot get build number
		exit /b 1
	)
	
	for /r %%i in (AssemblyInfo.cs) do (
		if exist "%%i" (
			call:process "%%i"
		)
	)
	
	C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\msbuild "%SOLUTION%" /p:Configuration=Release /p:WarningLevel=0 /nologo /v:m
	
	for /r %%i in (AssemblyInfo.cs) do (
		if exist "%%i" (
			move /y "%%~i.tmp" "%%~i"
		)
	)
	
	goto:eof

:process
	copy "%~1" "%~1.tmp" > nul
	attrib -r "%~1"
	sed -r -i ^
		-e "s/(AssemblyFileVersion..[0-9]+.[0-9]+.)[0-9]+.[0-9]+/\1%BUILD_NUMBER%.%R_NUMBER%/" ^
		"%~1"
	goto:eof