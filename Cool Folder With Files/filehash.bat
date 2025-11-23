@echo off
REM filehash.bat
setlocal

set /p "file=Enter full file path to hash: "
if not exist "%file%" (
  echo File not found.
  pause
  exit /b 1
)

echo Calculating SHA256 for "%file%"...
certutil -hashfile "%file%" SHA256
pause
endlocal
