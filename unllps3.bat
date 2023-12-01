@echo off
@setlocal

@REM This make file extracts the Python code from Lego SPIKE llsp3 (zip).
@REM It relies on `unzip` and `jq` command line tools that can be found in cygwin or git

unzip -q "%~nx1" -d "%~n1"
if exist "%~n1\projectbody.json" (
    jq -r .main "%~n1\projectbody.json" > "%~n1\%~n1.py"
)
