@echo off

set UTILS_HOME=C:\utils

REM it seems doskey is not very stable when other processes are trying to
REM start cmd in hidden mode.
REM alias
rem doskey l=dir $*
rem doskey cd=%~dp0\scd.bat $*
rem doskey pn=%UTILS_HOME%\pn\pn.exe $*
rem doskey npp="C:\Program Files (x86)\Notepad++\notepad++.exe" $*
rem doskey vsvar="%VS90COMNTOOLS%vsvars32.bat"
rem doskey ahkw=start /wait %~dp0\ahk-scriptwriter\ahkwriter.exe --console --windowless $*
rem doskey ahki=%~dp0\ahk-scriptwriter\ahkimagetool.exe $*
rem doskey ahk=start /wait %UTILS_HOME%\autohotkey\autohotkey.exe $*
rem doskey alias=doskey /macros
rem doskey cropborder=java -jar %UTILS_HOME%\cropborder\cropborder.jar
rem doskey find=C:\cygwin64\bin\find.exe $*

rem if exist "C:\Program Files\7-Zip" (
rem 	doskey 7z="C:\Program Files\7-Zip\7z.exe" $*
rem )
rem doskey vi="%CYGWIN_HOME%\bin\vim-nox.exe" $*
rem doskey emacs="%CYGWIN_HOME%\bin\emacs-nox.exe" $*

set LESS=-Ri

set CYGWIN=nodosfilewarning
set PROMPT=$_$P$_$G

set MSBUILD_V4=C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
