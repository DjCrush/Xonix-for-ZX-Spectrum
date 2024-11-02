@echo off

cls

..\..\..\sjasmplus xonix.asm
if errorlevel 1 goto error
xonix.sna

:error

pause
