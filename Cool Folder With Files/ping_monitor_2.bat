@echo off
REM ping_monitor.bat
setlocal

set /p "host=Enter hostname or IP to monitor (ex: google.com): "
if "%host%"=="" exit /b

echo Monitoring %host% - press Ctrl+C to stop
:loop
  ping -n 1 "%host%" >nul
  if errorlevel 1 (
    echo %date% %time% - %host% is OFFLINE
  ) else (
    echo %date% %time% - %host% is ONLINE
  )
  timeout /t 2 >nul
goto loop

endlocal
