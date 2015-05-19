	@echo off
	@setlocal
	
	@set KEY=%~1
	@set PASSWD=%~2
	
	grep "^%KEY%:" "%USERPROFILE%\mypasswords.txt" | cut -f 2 | openssl enc -d -base64 | openssl enc -d -des3 -pass pass:%PASSWD% | clip -i