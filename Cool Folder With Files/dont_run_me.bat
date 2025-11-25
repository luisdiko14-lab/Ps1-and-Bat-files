echo off
SET /a i=0

:loop
IF %i%==100 GOTO END
echo This is iteration %i%. 
START cmd.exe /K "cd C:\bin\phantomjs-1.9.2-windows & phantomjs examples\loadspeed.js"
SET /a i=%i%+2
GOTO LOOP

:end
echo
