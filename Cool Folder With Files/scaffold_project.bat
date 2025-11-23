@echo off
REM scaffold_project.bat
setlocal

set /p "proj=Enter project name: "
if "%proj%"=="" (
  echo Project name required.
  pause
  exit /b 1
)

set "path=%CD%\%proj%"
if exist "%path%" (
  echo Folder already exists: %path%
  pause
  exit /b 1
)

mkdir "%path%"
mkdir "%path%\src"
mkdir "%path%\docs"
mkdir "%path%\tests"

(
echo # %proj%
echo.
echo Project scaffold created by Luis Toolkit.
echo.
echo ## Structure
echo - src: source files
echo - docs: documentation
echo - tests: test files
) > "%path%\README.md"

notepad "%path%\README.md"
echo Project scaffold created at %path%
pause
endlocal
