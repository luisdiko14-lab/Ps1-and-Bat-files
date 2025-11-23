@echo off
REM bulk_rename.bat
setlocal EnableDelayedExpansion

set /p "folder=Enter folder path to rename files in: "
if not exist "%folder%" (
  echo Folder not found.
  pause
  exit /b 1
)

set /p "mode=Type 'p' for prefix, 's' for suffix: "
if /I "%mode%"=="p" (
  set /p "text=Enter prefix text: "
  set "type=prefix"
) else (
  set /p "text=Enter suffix text (before extension): "
  set "type=suffix"
)

pushd "%folder%" || exit /b 1

set /a counter=1
for %%F in (*.*) do (
  set "name=%%~nF"
  set "ext=%%~xF"
  if /I "%type%"=="prefix" (
    ren "%%F" "%text%!name!%ext%"
  ) else (
    ren "%%F" "!name!%text%%ext%"
  )
  set /a counter+=1
)

popd
echo Done.
pause
endlocal
