@echo off
REM append_log.bat
setlocal

set "logdir=%USERPROFILE%\Desktop\LuisToolkitLogs"
if not exist "%logdir%" mkdir "%logdir%"

set "logfile=%logdir%\Log.txt"
set /p "msg=Enter log message: "
for /f "tokens=1-3 delims=/: " %%a in ("%date%") do set "d=%%c-%%a-%%b"
for /f "tokens=1-3 delims=:. " %%a in ("%time%") do set "t=%%a:%%b:%%c"

echo [%d% %t%] %msg% >> "%logfile%"
echo Appended to %logfile%
pause
endlocal
