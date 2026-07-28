@echo off

set UTILS_HOME="%~dp0..\utils"

REM it seems doskey is not very stable when other processes are trying to
REM start cmd in hidden mode. So do not set this auto run in registry for
REM cmd.
REM Also, doskey is slow. Prefer shims over doskey for frequently used commands.
REM alias

doskey cd=%~dp0\scd.bat $*

set LESS=-Ri

set CYGWIN=nodosfilewarning
set PROMPT=$_$P$_$G
