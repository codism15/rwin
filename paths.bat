	@echo off
	setlocal
	path | sed -e 's/PATH=//' -e 's/;/\n/g'
