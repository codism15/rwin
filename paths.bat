	@echo off
	setlocal
	echo %PATH% | sed -e 's/;/\n/g'
