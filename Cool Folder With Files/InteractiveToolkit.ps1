<#
InteractiveToolkit.ps1
Provides a console menu to run multiple utilities:
1) Show System Info Summary
2) Run Progress copy
3) Generate secure password
4) Monitor host ping (runs until user cancels)
5) Exit
#>

function Show-Menu {
    Clear-Host
    Write-Host "================ LUIS TOOLKIT (PowerShell) ================" -ForegroundColor Cyan
    Write-Host "1) Show system summary"
    Write-Host "2) Copy folder with progress"
    Write-Host "3) Generate secure password"
    Write-Host "4) Ping monitor"
    Write-Host "5) Exit"
    Write-Host "========================================================="
}

function Show-SystemSummary {
    Clear-Host
    Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture | Format-List
    Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model, TotalPhysicalMemory | Format-List
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N='FreeGB';E={[math]::Round($_.Free/1GB,2)}}, @{N='SizeGB';E={[math]::Round($_.Used/1GB + $_.Free/1GB,2)}} | Format-Table -AutoSize
    Pause
}

function Copy-WithProgress {
    $src = Read-Host "Source folder"
    if (-not (Test-Path $src)) { Write-Host "Source not found." -ForegroundColor Red; return }
    $dst = Read-Host "Destination folder (leave empty to create on Desktop)"
    if ([string]::IsNullOrWhiteSpace($dst)) { $dst = Join-Path $env:USERPROFILE ("Desktop\Copy_" + (Get-Date -Format 'yyyyMMdd_HHmmss')) }
    New-Item -ItemType Directory -Path $dst -Force | Out-Null

    $files = Get-ChildItem -Path $src -Recurse -File
    $total = $files.Count
    $i = 0
    foreach ($f in $files) {
        $i++
        $destPath = Join-Path $dst ($f.FullName.Substring($src.Length).TrimStart('\'))
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item -Path $f.FullName -Destination $destPath -Force
        $percent = [math]::Round(($i / $total) * 100)
        Write-Progress -Activity "Copying files" -Status "$i of $total" -PercentComplete $percent
    }
    Write-Progress -Activity "Copying files" -Completed -Status "Done"
    Write-Host "Copy complete to $dst" -ForegroundColor Green
    Pause
}

function Generate-Password {
    param([int]$Length = 16)
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"
    $rnd = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $bytes = New-Object byte[] $Length
    $rnd.GetBytes($bytes)
    $sb = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $Length; $i++) {
        $idx = $bytes[$i] % $chars.Length
        [void]$sb.Append($chars[$idx])
    }
    $pwd = $sb.ToString()
    $pwd | Set-Clipboard
    Write-Host "Password generated and copied to clipboard: $pwd" -ForegroundColor Yellow
    Pause
}

function Ping-Monitor {
    $host = Read-Host "Host to monitor (ex: google.com)"
    if ([string]::IsNullOrWhiteSpace($host)) { return }
    Write-Host "Monitoring $host. Press Ctrl+C to stop."
    while ($true) {
        $ok = Test-Connection -ComputerName $host -Count 1 -Quiet
        if ($ok) { Write-Host "$(Get-Date -Format 'HH:mm:ss') - $host ONLINE" -ForegroundColor Green }
        else { Write-Host "$(Get-Date -Format 'HH:mm:ss') - $host OFFLINE" -ForegroundColor Red }
        Start-Sleep -Seconds 2
    }
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Choose an option"
    switch ($choice) {
        '1' { Show-SystemSummary }
        '2' { Copy-WithProgress }
        '3' { $len = Read-Host "Password length (default 16)"; if (-not $len) { $len = 16 }; Generate-Password -Length [int]$len }
        '4' { Ping-Monitor }
        '5' { break }
        default { Write-Host "Invalid option." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}
