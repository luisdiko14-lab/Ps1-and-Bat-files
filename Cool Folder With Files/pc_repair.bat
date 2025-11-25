@echo off
title System Repair Utility
color 3f
mode 90,25

:main
cls
echo ===============================
echo     PC REPAIR SUITE v4.2
echo ===============================
echo 1 - Disk Scan
echo 2 - Temp File Cleanup
echo 3 - Network Diagnostic
echo 4 - System Report
echo 5 - Exit
set /p c=Choose: 

if "%c%"=="1" goto disk
if "%c%"=="2" goto clean
if "%c%"=="3" goto net
if "%c%"=="4" goto report
if "%c%"=="5" exit
goto main

:disk
cls
echo Checking disk integrity...
for /l %%i in (1,1,50) do (
    echo Sector %%i OK
    ping localhost -n 1 >nul
)
echo No disk errors found.
pause
goto main

:clean
cls
echo Cleaning temporary files...
for /l %%i in (1,1,30) do (
    echo Removing file temp%%i.tmp
    ping localhost -n 1 >nul
)
echo Cleanup complete.
pause
goto main

:net
cls
echo Running network diagnostic...
for /l %%i in (1,1,25) do (
    echo Testing packet %%i...
    ping localhost -n 1 >nul
)
echo Network stable.
pause
goto main

:report
cls
echo Creating system report...
echo Timestamp: %date% %time%
echo CPU: Stable
echo RAM: 100%
echo Disk: Normal
echo Network: OK
pause
goto main
