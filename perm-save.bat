@echo off
setlocal

icacls "%~1" /save C:\tmp\perms.txt /c

@rem to restore permission settings to a different folder on d:
@rem icacls . /restore C:\tmp\perms.txt /c