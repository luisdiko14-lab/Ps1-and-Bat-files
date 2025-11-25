@echo off
title Dungeon Quest
color 0e

set hp=100
set gold=0

:menu
cls
echo =====================
echo     DUNGEON QUEST
echo =====================
echo HP: %hp%    Gold: %gold%
echo 1 - Enter the Dungeon
echo 2 - Visit Shop
echo 3 - Quit
set /p m=Choose: 

if "%m%"=="1" goto dungeon
if "%m%"=="2" goto shop
if "%m%"=="3" exit
goto menu

:dungeon
cls
echo You encounter a monster!
set /a dmg=%random% %% 40 + 5
set /a hp=%hp%-%dmg%
echo The monster hits you for %dmg% damage!

set /a loot=%random% %% 20 + 1
set /a gold=%gold%+%loot%
echo You defeat it and gain %loot% gold!

if %hp% LEQ 0 (
    echo YOU HAVE DIED.
    pause
    exit
)

pause
goto menu

:shop
cls
echo Welcome to the shop!
echo 1 - Heal (20 gold)
echo 2 - Leave
set /p s=Choose: 

if "%s%"=="1" (
    if %gold% GEQ 20 (
        set /a gold=%gold%-20
        set hp=100
        echo Fully healed!
    ) else (
        echo Not enough gold!
    )
    pause
    goto menu
)

goto menu
