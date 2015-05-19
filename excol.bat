	@echo off
	REM view one-line exception message in the clipboard
	
	rclip | sed -r ^
		-e 's/ +at/\n@/g' ^
		-e 's/\) in /\)\n  @ /g' ^
		-e 's/     ---/\n---/g' ^
		-e 's/\.  /\.\n/g' ^
		-e 's/Lakshmi.*(\\\\[a-z0-9_.]*\\\\[a-z0-9_.]*)/...\1/gi' ^
		-e 's/System.Runtime.Serialization/Serialization/g' ^
		-e 's/System.Data.SqlClient/SqlClient/g' ^
		-e 's/Crossmark./Cmk./g' ^
		-e 's/ServiceForce/SF/g'