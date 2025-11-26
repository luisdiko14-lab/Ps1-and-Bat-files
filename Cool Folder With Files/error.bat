@echo off
setlocal enabledelayedexpansion

:: Loop 1000 times
for /L %%i in (1,2,1000) do (
    :: Random weird characters
    set "chars=!random!!random!!random!"
    :: Show message box
    start "" mshta "javascript:alert('Error !chars!');close();"
)

exit
