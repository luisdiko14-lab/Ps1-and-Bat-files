@echo off
REM disk_summary.bat
powershell -NoProfile -Command ^
"Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='Used(GB)';Expression={[math]::Round(($_.Used/1GB),2)}}, @{Name='Free(GB)';Expression={[math]::Round(($_.Free/1GB),2)}}, @{Name='Root';Expression={$_.Root}} | Format-Table -AutoSize"
pause
