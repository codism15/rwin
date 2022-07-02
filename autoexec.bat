@echo off

set UTILS_HOME=C:\utils

REM it seems doskey is not very stable when other processes are trying to
REM start cmd in hidden mode. So do not set this auto run in registry for
REM cmd.
REM 
REM alias
doskey l=dir $*
doskey cd=%~dp0\scd.bat $*
doskey code="C:\Users\lplus\AppData\Local\Programs\Microsoft VS Code\Code.exe" $*
doskey npp="C:\Program Files (x86)\Notepad++\notepad++.exe" $*
doskey alias=doskey /macros
doskey find=C:\cygwin64\bin\find.exe $*

rem if exist "C:\Program Files\7-Zip" (
rem 	doskey 7z="C:\Program Files\7-Zip\7z.exe" $*
rem )
rem doskey vi="%CYGWIN_HOME%\bin\vim-nox.exe" $*
rem doskey emacs="%CYGWIN_HOME%\bin\emacs-nox.exe" $*

set LESS=-Ri

set CYGWIN=nodosfilewarning
set PROMPT=$_$P$_$G
