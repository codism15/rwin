@echo off

set UTILS_HOME=C:\utils

REM alias
doskey l=dir $*
doskey cd=%~dp0\scd.bat $*
doskey pn=%UTILS_HOME%\pn\pn.exe $*
doskey npp="C:\Program Files (x86)\Notepad++\notepad++.exe" $*
doskey vsvar="%VS90COMNTOOLS%vsvars32.bat"
doskey ahkw=start /wait %~dp0\ahk-scriptwriter\ahkwriter.exe --console --windowless $*
doskey ahki=%~dp0\ahk-scriptwriter\ahkimagetool.exe $*
doskey ahk=start /wait %UTILS_HOME%\autohotkey\autohotkey.exe $*
doskey alias=doskey /macros
doskey cropborder=java -jar %UTILS_HOME%\cropborder\cropborder.jar
doskey paths=path ^| sed -e 's/PATH=//' -e 's/;/\n/g'

if exist "C:\Program Files\7-Zip" (
	doskey 7z="C:\Program Files\7-Zip\7z.exe" $*
)
rem doskey vi="%CYGWIN_HOME%\bin\vim-nox.exe" $*
doskey emacs="%CYGWIN_HOME%\bin\emacs-nox.exe" $*

set LESS=-Ri

set CYGWIN=nodosfilewarning
set PROMPT=$P$_$G

set MSBUILD_V4=C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
