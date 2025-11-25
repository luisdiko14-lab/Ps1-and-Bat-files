@echo off
title SYSTEM UTILITY - MULTI PHASE MODE
color 0a

:main
cls
echo ============================================
echo        WELCOME TO SYSTEM UTILITY
echo ============================================
echo.
echo 1 - Phase 1 (Safe Operations)
echo 2 - Phase 2 (Questionable Operations)
echo 3 - Phase 3 (Very Suspicious)
echo 4 - System Info
echo 5 - Exit
echo.
set /p choice=Select an option ^> 

if "%choice%"=="1" goto phase1
if "%choice%"=="2" goto phase2
if "%choice%"=="3" goto phase3
if "%choice%"=="4" goto sysinfo
if "%choice%"=="5" exit
goto main

rem =============================================
rem PHASE 1 - SAFE
rem =============================================
:phase1
cls
echo [PHASE 1] SAFE OPTIONS
echo.
echo 1 - Show Date and Time
echo 2 - Check Internet Connection
echo 3 - Return to Menu
echo.
set /p p1=Choose ^> 

if "%p1%"=="1" (
    echo.
    echo Current Date: %date%
    echo Current Time: %time%
    pause
    goto phase1
)

if "%p1%"=="2" (
    echo Testing internet connection...
    ping google.com
    pause
    goto phase1
)

goto main


rem =============================================
rem PHASE 2 - KINDA NOT GOOD
rem =============================================
:phase2
cls
echo [PHASE 2] KINDA SKETCHY
echo.
echo 1 - Kill Notepad If Running
echo 2 - Flood Console With Text
echo 3 - Return to Menu
echo.
set /p p2=Choose ^> 

if "%p2%"=="1" (
    echo Attempting to close notepad.exe...
    taskkill /IM notepad.exe /F >nul 2>&1
    echo Done.
    pause
    goto phase2
)

if "%p2%"=="2" (
    for /l %%a in (1,1,200) do echo SYSTEM WARNING %%a!!!
    pause
    goto phase2
)

goto main


rem =============================================
rem PHASE 3 - VERY SUS
rem =============================================
:phase3
cls
color 0c
echo [PHASE 3] YOU SHOULDN'T BE HERE
echo.
echo 1 - Fake Virus Loading Screen
echo 2 - Screen Flicker Attack
echo 3 - Return to Menu
echo.
set /p p3=Choose ^> 

if "%p3%"=="1" goto virus
if "%p3%"=="2" goto flicker
goto main


:virus
cls
echo INITIALIZING...
ping localhost -n 2 >nul
echo LOADING MALWARE ENGINE...
ping localhost -n 2 >nul

for /l %%a in (1,1,50) do (
    echo Progress: %%a percent
    ping localhost -n 1 >nul
)

echo ERROR: YOU HAVE BEEN INFECTED!!!
ping localhost -n 2 >nul
echo Just kidding lol.
pause
goto phase3


:flicker
for /l %%a in (1,1,30) do (
    color 0c
    ping localhost -n 1 >nul
    color 0a
    ping localhost -n 1 >nul
)
pause
goto phase3


rem =============================================
rem EXTRA - SYSTEM INFO
rem =============================================
:sysinfo
cls
echo GATHERING SYSTEM INFORMATION...
ping localhost -n 2 >nul
systeminfo | more
pause
goto main
