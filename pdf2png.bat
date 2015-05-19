	@echo off
	@setlocal
	
	gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r200 -dTextAlphaBits=4 -sOutputFile="%~n1-%%00d.png" %1
	