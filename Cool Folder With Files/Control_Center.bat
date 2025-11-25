@echo off
title SYSTEM CONTROL CENTER
color 0a

:: ==============================
:: BOOT SEQUENCE
:: ==============================
cls
echo Booting System Control Center...
ping localhost -n 2 >nul

echo Initializing components...
ping localhost -n 2 >nul

for /l %%a in (1,1,30) do (
    echo Loading %%a/30
    ping localhost -n 1 >nul
)

:: Password gate
set pass=system123
:login
cls
echo =====================================
echo      SYSTEM CONTROL CENTER LOGIN
echo =====================================
echo.
set /p input=Enter Password ^> 

if "%input%"=="%pass%" goto menu
echo Incorrect password!
ping localhost -n 2 >nul
goto login


:: ==============================
:: MAIN MENU
:: ==============================
:menu
cls
echo =====================================
echo        SYSTEM CONTROL CENTER
echo =====================================
echo.
echo 1 - System Scan
echo 2 - AI Terminal
echo 3 - Tools & Utilities
echo 4 - Fake Hacker Mode
echo 5 - Shutdown Program
echo.
set /p m=Select an option ^> 

if "%m%"=="1" goto scan
if "%m%"=="2" goto ai
if "%m%"=="3" goto tools
if "%m%"=="4" goto hack
if "%m%"=="5" exit
goto menu


:: ==============================
:: SYSTEM SCAN
:: ==============================
:scan
cls
echo Performing deep system scan...
ping localhost -n 2 >nul

for /l %%a in (1,1,50) do (
    echo Scanning module %%a...
    ping localhost -n 1 >nul
)

echo.
echo No threats detected. System stable.
pause
goto menu


:: ==============================
:: AI TERMINAL
:: ==============================
:ai
cls
echo ========== AI COMMAND TERMINAL ==========
echo.
echo Type a sentence and AI will "respond".
echo Type EXIT to return.
echo.

:ai_loop
set /p ai_input=[You] ^> 

if /i "%ai_input%"=="exit" goto menu

echo [AI] Thinking...
ping localhost -n 2 >nul

:: Fake responses
set /a r=%random% %% 5

if %r%==0 echo [AI] Interesting response.
if %r%==1 echo [AI] I understand completely.
if %r%==2 echo [AI] Processing your emotions...
if %r%==3 echo [AI] I would agree with that.
if %r%==4 echo [AI] Noted.

goto ai_loop


:: ==============================
:: TOOLS MENU
:: ==============================
:tools
cls
echo ========== UTILITIES ==========
echo.
echo 1 - Show system date/time
echo 2 - Network check
echo 3 - Kill Notepad.exe
echo 4 - Return
echo.
set /p t=Choose ^> 

if "%t%"=="1" (
    echo.
    echo Date: %date%
    echo Time: %time%
    pause
    goto tools
)

if "%t%"=="2" (
    echo Pinging Google...
    ping google.com
    pause
    goto tools
)

if "%t%"=="3" (
    echo Attempting to close Notepad...
    taskkill /IM notepad.exe /F >nul 2>&1
    echo Done.
    pause
    goto tools
)

goto menu


:: ==============================
:: HACKER MODE (Fun FX)
:: ==============================
:hack
cls
color 0a
echo Entering Hacker Mode...
ping localhost -n 2 >nul

for /l %%x in (1,1,200) do (
    echo ACCESS LOG: Packet %%x decrypted successfully.
)

echo.
echo Fake firewall bypassed.
echo Terminal open.
pause

for /l %%z in (1,1,20) do (
    color 0a
    ping localhost -n 1 >nul
    color 0c
    ping localhost -n 1 >nul
)

echo.
echo SYSTEM OVERRIDE COMPLETE
pause
goto menu
