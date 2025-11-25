@echo off
title Windows 98 Simulator
color 1f
mode 80,25

cls
echo Starting Windows 98...
ping localhost -n 2 >nul

for /l %%a in (1,1,35) do (
    echo Loading system driver %%a
    ping localhost -n 1 >nul
)

cls
echo ============================
echo   Welcome to Windows 98
echo ============================
echo.
echo 1 - My Computer
echo 2 - Control Panel
echo 3 - DOS Prompt
echo 4 - Shut Down
echo.
set /p c=Select Option: 

if "%c%"=="1" goto comp
if "%c%"=="2" goto control
if "%c%"=="3" goto dos
if "%c%"=="4" exit
goto top

:comp
cls
echo My Computer
echo Hard Disk C:\
echo Floppy A:\
echo CD-ROM D:\
pause
goto win

:control
cls
echo Control Panel
echo Display
echo Power
echo Modem
pause
goto win

:dos
cls
echo Entering DOS mode...
ping localhost -n 2 >nul
cmd
goto win

:win
goto top
