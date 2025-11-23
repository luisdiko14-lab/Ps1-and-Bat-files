@echo off
REM zip_folder.bat
setlocal

set /p "src=Enter folder to zip (full path): "
if not exist "%src%" (
  echo Folder not found.
  pause
  exit /b 1
)

set /p "zipname=Enter destination zip name (without .zip) or press Enter to use folder name: "
if "%zipname%"=="" (
  for %%F in ("%src%") do set "zipname=%%~nF"
)

set "dest=%CD%\%zipname%.zip"
powershell -NoProfile -Command "Compress-Archive -Path '%src%\*' -DestinationPath '%dest%' -Force"
if exist "%dest%" (
  echo Created %dest%
) else (
  echo Failed to create zip.
)
pause
endlocal
