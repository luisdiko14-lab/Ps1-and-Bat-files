<#
FolderWatcher.ps1
Watches a folder and logs Created/Changed/Deleted events. Safe and uses FileSystemWatcher.
#>

param(
    [string]$PathToWatch = (Read-Host "Enter folder to watch (full path)"),
    [string]$LogFile = (Join-Path $env:USERPROFILE "Desktop\FolderWatcherLog.txt")
)

if (-not (Test-Path $PathToWatch)) {
    Write-Host "Path does not exist: $PathToWatch" -ForegroundColor Red
    exit 1
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $PathToWatch
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    param($sender, $e)
    $msg = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$($e.ChangeType)] $($e.FullPath)"
    $msg | Out-File -FilePath $using:LogFile -Append -Encoding UTF8
    Write-Host $msg
}

$created = Register-ObjectEvent $watcher Created -Action $action
$changed = Register-ObjectEvent $watcher Changed -Action $action
$deleted = Register-ObjectEvent $watcher Deleted -Action $action
$renamed = Register-ObjectEvent $watcher Renamed -Action {
    param($sender, $e)
    $msg = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [Renamed] From: $($e.OldFullPath) To: $($e.FullPath)"
    $msg | Out-File -FilePath $using:LogFile -Append -Encoding UTF8
    Write-Host $msg
}

Write-Host "Watching $PathToWatch. Events will be logged to $LogFile"
Write-Host "Press Enter to stop."
[void][System.Console]::ReadLine()

# Cleanup
Unregister-Event -SourceIdentifier $created.Name -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier $changed.Name -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier $deleted.Name -ErrorAction SilentlyContinue
Unregister-Event -SourceIdentifier $renamed.Name -ErrorAction SilentlyContinue
$watcher.EnableRaisingEvents = $false
$watcher.Dispose()
Write-Host "Stopped watching."
