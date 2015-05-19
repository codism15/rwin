@echo off
setlocal

REM this tool refreshes an IP in the windows host file
REM by the returned text from an URL.

set "URL=%~1"
set "COMPUTER_NAME=%~2"

if NOT DEFINED URL goto:help
IF NOT defined COMPUTER_NAME goto:help

set HOST_DIR=%windir%\System32\drivers\etc

pushd %HOST_DIR%

for /f "usebackq" %%i in (`curl "%URL%" ^| head -n 1 ^| grep -Eo "[0-9]{1,3}(\.[0-9]{1,3}){3}"`) do (
	set "NEWIP=%%i"
)

if errorlevel 1 exit /b 1

echo %NEWIP%

ruby -pe "$_.gsub!(/\d{1,3}(\.\d{1,3}){3}/, '%NEWIP%') if $_=~ /^[\d\.]+\s+%COMPUTER_NAME%/" hosts > hosts-new

if errorlevel 1 exit /b 1

move /y hosts hosts.bak

move hosts-new hosts

exit /b 0

:help
echo refresh-hosts http://server machine-name
exit /b 1

:onerr
pause
exit /b 1