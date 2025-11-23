<#
SystemInfoLogger.ps1
Gathers detailed system information and writes a timestamped report to the Desktop.
#>

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outFile = Join-Path $env:USERPROFILE "Desktop\SystemInfo_$timestamp.txt"

function Write-Section($title) {
    "`n===== $title =====`n" | Out-File -FilePath $outFile -Append -Encoding UTF8
}

"System info report generated: $(Get-Date)" | Out-File -FilePath $outFile -Encoding UTF8

Write-Section "Computer and OS"
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer, Model, Name, UserName, TotalPhysicalMemory |
    Format-List | Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture | Format-List |
    Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Write-Section "CPU"
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed |
    Format-List | Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Write-Section "Disk Drives"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, VolumeName, @{Name='SizeGB';Expression={[math]::Round($_.Size/1GB,2)}}, @{Name='FreeGB';Expression={[math]::Round($_.FreeSpace/1GB,2)}} |
    Format-Table -AutoSize | Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Write-Section "Network Adapters (IP info)"
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize |
    Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Write-Section "Installed Programs (top 30)"
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* ,
HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
    Where-Object { $_.DisplayName } | Sort-Object DisplayName |
    Select-Object -First 30 | Format-Table -AutoSize | Out-String | Out-File -FilePath $outFile -Append -Encoding UTF8

Write-Host "System info saved to $outFile" -ForegroundColor Green
