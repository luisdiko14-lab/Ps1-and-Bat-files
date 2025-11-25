@echo off
title RETRO OS v3.7
color 0a

:: ==========================
:: BOOT SCREEN
:: ==========================
cls
echo Starting RETRO OS...
ping localhost -n 2 >nul

for /l %%a in (1,1,30) do (
    echo Booting Kernel Module %%a...
    ping localhost -n 1 >nul
)

echo.
echo Loading Drivers...
ping localhost -n 2 >nul

:: ==========================
:: LOGIN
:: ==========================
set username=User
:login
cls
echo ===================================
echo           RETRO OS LOGIN
echo ===================================
echo.
set /p in=Enter username ^> 

if "%in%"=="" goto login
set username=%in%
goto desktop


:: ==========================
:: DESKTOP
:: ==========================
:desktop
cls
echo =====================================================
echo                    RETRO OS v3.7
echo =====================================================
echo  Logged in as: %username%
echo -----------------------------------------------------
echo  1 - Terminal
echo  2 - Applications
echo  3 - System Information
echo  4 - Shutdown
echo.
set /p d=Choose an option ^> 

if "%d%"=="1" goto terminal
if "%d%"=="2" goto apps
if "%d%"=="3" goto sys
if "%d%"=="4" exit
goto desktop

:: ==========================
:: TERMINAL
:: ==========================
:terminal
cls
echo ============== RETRO TERMINAL ==============
echo Type HELP for commands.
echo Type EXIT to return.
echo.

:terminal_loop
set /p cmd=retro:\> 

if /i "%cmd%"=="exit" goto desktop

if /i "%cmd%"=="help" (
    echo.
    echo Commands:
    echo help   - Show this help
    echo time   - Show system time
    echo date   - Show system date
    echo cls    - Clear screen
    echo ping   - Fake ping diagnostic
    echo exit   - Return to desktop
    echo.
    goto terminal_loop
)

if /i "%cmd%"=="time" (
    echo Current time: %time%
    goto terminal_loop
)

if /i "%cmd%"=="date" (
    echo Current date: %date%
    goto terminal_loop
)

if /i "%cmd%"=="cls" (
    cls
    goto terminal_loop
)

if /i "%cmd%"=="ping" (
    echo Running network diagnostic...
    ping localhost -n 2 >nul
    for /l %%a in (1,1,10) do (
        echo Packet %%a received successfully.
        ping localhost -n 1 >nul >nul
    )
    goto terminal_loop
)

echo Unknown command: %cmd%
goto terminal_loop


:: ==========================
:: APPLICATIONS MENU
:: ==========================
:apps
cls
echo ============== APPLICATIONS ==============
echo.
echo 1 - Calculator
echo 2 - Notes
echo 3 - Digital Clock
echo 4 - Go Back
echo.
set /p app=Choose ^> 

if "%app%"=="1" goto calc
if "%app%"=="2" goto notes
if "%app%"=="3" goto clock
goto desktop


:: ==========================
:: CALCULATOR
:: ==========================
:calc
cls
echo SIMPLE CALCULATOR
echo Enter EXIT to go back.
echo.

:calc_loop
set /p operation=Enter a math expression (ex: 5+10) ^> 
if /i "%operation%"=="exit" goto apps

set /a result=%operation% >nul 2>&1

if errorlevel 1 (
    echo Invalid expression!
) else (
    echo Result: %result%
)
goto calc_loop


:: ==========================
:: NOTES APP
:: ==========================
:notes
cls
echo ================= NOTES ================
echo Type notes below. 
echo Type SAVE to store.
echo Type EXIT to go back.
echo.

set note=
:note_loop
set /p line=> 

if /i "%line%"=="exit" goto apps

if /i "%line%"=="save" (
    echo %note% > retro_notes.txt
    echo Saved to retro_notes.txt
    pause
    goto apps
)

set note=%note% %line%
goto note_loop


:: ==========================
:: DIGITAL CLOCK
:: ==========================
:clock
cls
echo ======= DIGITAL CLOCK =======
echo Press CTRL + C to exit.
echo.

:clock_loop
cls
echo Time: %time%
ping localhost -n 2 >nul
goto clock_loop


:: ==========================
:: SYSTEM INFORMATION
:: ==========================
:sys
cls
echo ========== SYSTEM INFORMATION ==========
echo.
echo User: %username%
echo Date: %date%
echo Time: %time%
echo.
echo CPU Model: Retro 8-bit Processor
echo RAM: 4096 KB
echo OS Version: v3.7
echo Status: Stable
echo.
pause
goto desktop
