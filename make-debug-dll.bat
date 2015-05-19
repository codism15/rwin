:: Assume you are working in a sub-folder of the original folder
:: USAGE: make-debug-dll System.Windows.Form

copy ..\%1.dll %1.orig.dll

ildasm /out=%1.il /source /linenum /nobar ..\%1.dll

ilasm /DEBUG /DLL /QUIET /OUTPUT=%1.dll %1.il

sn -Vr %1.dll

:: copy %1.dll ..

:: gacutil /i %1.dll

