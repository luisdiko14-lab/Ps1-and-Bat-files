@echo off
REM open_sites_menu.bat
setlocal

:menu
cls
echo === Open Favorite Sites ===
echo 1) YouTube
echo 2) Google
echo 3) GitHub
echo 4) Discord
echo 5) Open all
echo 0) Exit
set /p choice="Choose an option: "

if "%choice%"=="1" start "" "https://www.youtube.com" & goto menu
if "%choice%"=="2" start "" "https://www.google.com" & goto menu
if "%choice%"=="3" start "" "https://github.com" & goto menu
if "%choice%"=="4" start "" "https://discord.com" & goto menu
if "%choice%"=="5" (
  start "" "https://www.youtube.com"
  start "" "https://www.google.com"
  start "" "https://github.com"
  start "" "https://discord.com"
  goto menu
)
if "%choice%"=="0" goto :eof

echo Invalid choice.
pause
goto menu

endlocal
