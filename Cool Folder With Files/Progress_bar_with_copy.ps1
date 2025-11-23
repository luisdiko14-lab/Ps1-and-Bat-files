<#
ProgressBarWithCopy.ps1
Copies files from a source folder to a destination, shows progress with Write-Progress,
and writes a log file to the destination. Uses robust error handling.
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Source = (Read-Host "Enter source folder path"),
    [Parameter(Mandatory=$false)]
    [string]$Destination = (Join-Path -Path $env:USERPROFILE -ChildPath ("Desktop\Copied_" + (Get-Date -Format 'yyyyMMdd_HHmmss')))
)

try {
    if (-not (Test-Path -Path $Source -PathType Container)) {
        throw "Source folder not found: $Source"
    }

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    $logFile = Join-Path $Destination "CopyLog.txt"
    "Copy started: $(Get-Date)" | Out-File -FilePath $logFile -Encoding UTF8

    $files = Get-ChildItem -Path $Source -Recurse -File
    $total = $files.Count
    if ($total -eq 0) {
        "No files found in source." | Tee-Object -FilePath $logFile -Append
        Write-Host "No files to copy." -ForegroundColor Yellow
        exit 0
    }

    $count = 0
    foreach ($f in $files) {
        $relative = $f.FullName.Substring($Source.Length).TrimStart('\')
        $destPath = Join-Path $Destination $relative
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item -Path $f.FullName -Destination $destPath -Force

        $count++
        $percent = [math]::Round(($count / $total) * 100, 0)
        Write-Progress -Activity "Copying files" -Status "$count of $total : $percent% complete" -PercentComplete $percent
        "$count/$total - Copied: $relative" | Out-File -FilePath $logFile -Append -Encoding UTF8
    }

    Write-Progress -Activity "Copying files" -Completed -Status "Done"
    "Copy finished: $(Get-Date)" | Out-File -FilePath $logFile -Append -Encoding UTF8
    Write-Host "Copy finished. Log saved to $logFile" -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    if ($logFile) { "Error: $_" | Out-File -FilePath $logFile -Append -Encoding UTF8 }
    exit 1
}
