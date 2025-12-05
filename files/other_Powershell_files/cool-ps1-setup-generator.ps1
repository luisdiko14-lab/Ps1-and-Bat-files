<#
PowerShell script: cool-ps1-setup-generator.ps1
Purpose: Interactive GUI tool that scaffolds a folder with a given name, creates configuration.bat,
several helper files, a README, an optional scheduled task/shortcut, and a basic log.
- Designed to be robust and verbose with progress & logging.
- Cross-Windows compatible (uses Windows Forms).

Usage: Right-click -> Run with PowerShell, or run from PowerShell 5+.
Do NOT run untrusted scripts. This script writes files into the chosen folder.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$Script:LogFile = "$env:TEMP\cool-ps1-generator.log"
$Script:CancelRequested = $false

function Log {
    param(
        [Parameter(Mandatory=$true)][string]$Message
    )
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$time] $Message"
    Add-Content -Path $Script:LogFile -Value $line -Force
}

function SafeNew-Item {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$false)][string]$Content = $null
    )
    try {
        $dir = Split-Path -Parent $Path
        if ($dir -and -not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Log "Created directory: $dir"
        }
        Set-Content -Path $Path -Value $Content -Force -ErrorAction Stop
        Log "Wrote file: $Path"
    }
    catch {
        Log "ERROR writing file $Path - $_"
        throw
    }
}

function Create-Shortcut {
    param(
        [Parameter(Mandatory=$true)][string]$TargetPath,
        [Parameter(Mandatory=$true)][string]$ShortcutPath,
        [string]$Arguments = "",
        [string]$WorkingDirectory = "",
        [string]$Description = "",
        [string]$IconLocation = ""
    )
    try {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($ShortcutPath)
        $shortcut.TargetPath = $TargetPath
        if ($Arguments) { $shortcut.Arguments = $Arguments }
        if ($WorkingDirectory) { $shortcut.WorkingDirectory = $WorkingDirectory }
        if ($Description) { $shortcut.Description = $Description }
        if ($IconLocation) { $shortcut.IconLocation = $IconLocation }
        $shortcut.Save()
        Log "Created shortcut: $ShortcutPath -> $TargetPath"
    } catch {
        Log "Failed to create shortcut $ShortcutPath: $_"
    }
}

function Confirm-Overwrite {
    param(
        [string]$Path
    )
    if (Test-Path $Path) {
        $res = [System.Windows.Forms.MessageBox]::Show("$Path already exists. Overwrite?","Confirm Overwrite",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
        return $res -eq [System.Windows.Forms.DialogResult]::Yes
    }
    return $true
}

# Build the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Cool PS1 Setup Generator"
$form.Size = New-Object System.Drawing.Size(780,520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Controls: Label + textbox for folder name
$lblName = New-Object System.Windows.Forms.Label
$lblName.Location = New-Object System.Drawing.Point(14,18)
$lblName.Size = New-Object System.Drawing.Size(120,22)
$lblName.Text = "Project Folder Name:"
$form.Controls.Add($lblName)

$txtName = New-Object System.Windows.Forms.TextBox
$txtName.Location = New-Object System.Drawing.Point(140,14)
$txtName.Size = New-Object System.Drawing.Size(420,26)
$txtName.Text = "MyCoolProject"
$form.Controls.Add($txtName)

# Choose base path
$lblPath = New-Object System.Windows.Forms.Label
$lblPath.Location = New-Object System.Drawing.Point(14,56)
$lblPath.Size = New-Object System.Drawing.Size(120,22)
$lblPath.Text = "Base Path:"
$form.Controls.Add($lblPath)

$txtPath = New-Object System.Windows.Forms.TextBox
$txtPath.Location = New-Object System.Drawing.Point(140,52)
$txtPath.Size = New-Object System.Drawing.Size(420,26)
$txtPath.Text = [Environment]::GetFolderPath('Desktop')
$form.Controls.Add($txtPath)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Location = New-Object System.Drawing.Point(570,50)
$btnBrowse.Size = New-Object System.Drawing.Size(80,28)
$btnBrowse.Text = "Browse..."
$btnBrowse.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.SelectedPath = $txtPath.Text
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtPath.Text = $folderBrowser.SelectedPath
    }
})
$form.Controls.Add($btnBrowse)

# Description/notes
$lblDesc = New-Object System.Windows.Forms.Label
$lblDesc.Location = New-Object System.Drawing.Point(14,94)
$lblDesc.Size = New-Object System.Drawing.Size(120,22)
$lblDesc.Text = "Description:"
$form.Controls.Add($lblDesc)

$txtDesc = New-Object System.Windows.Forms.TextBox
$txtDesc.Location = New-Object System.Drawing.Point(140,90)
$txtDesc.Size = New-Object System.Drawing.Size(510,70)
$txtDesc.Multiline = $true
$txtDesc.ScrollBars = 'Vertical'
$txtDesc.Text = "A very cool generated project scaffold created by cool-ps1-setup-generator." 
$form.Controls.Add($txtDesc)

# Checkboxes for optional extras
$chkBat = New-Object System.Windows.Forms.CheckBox
$chkBat.Location = New-Object System.Drawing.Point(14,180)
$chkBat.Size = New-Object System.Drawing.Size(260,22)
$chkBat.Text = "Generate configuration.bat (Windows batch)"
$chkBat.Checked = $true
$form.Controls.Add($chkBat)

$chkExtraFiles = New-Object System.Windows.Forms.CheckBox
$chkExtraFiles.Location = New-Object System.Drawing.Point(14,208)
$chkExtraFiles.Size = New-Object System.Drawing.Size(260,22)
$chkExtraFiles.Text = "Create extra helper files (README, sample.ps1, .gitignore)"
$chkExtraFiles.Checked = $true
$form.Controls.Add($chkExtraFiles)

$chkShortcut = New-Object System.Windows.Forms.CheckBox
$chkShortcut.Location = New-Object System.Drawing.Point(14,236)
$chkShortcut.Size = New-Object System.Drawing.Size(260,22)
$chkShortcut.Text = "Create Desktop shortcut to open folder"
$chkShortcut.Checked = $true
$form.Controls.Add($chkShortcut)

$chkLog = New-Object System.Windows.Forms.CheckBox
$chkLog.Location = New-Object System.Drawing.Point(14,264)
$chkLog.Size = New-Object System.Drawing.Size(260,22)
$chkLog.Text = "Enable detailed log file"
$chkLog.Checked = $true
$form.Controls.Add($chkLog)

# Progress bar
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(14,300)
$progress.Size = New-Object System.Drawing.Size(740,22)
$progress.Minimum = 0
$progress.Maximum = 100
$progress.Value = 0
$form.Controls.Add($progress)

# Output textbox (multi-line) - shows step-by-step
$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location = New-Object System.Drawing.Point(14,340)
$txtOutput.Size = New-Object System.Drawing.Size(740,120)
$txtOutput.Multiline = $true
$txtOutput.ScrollBars = 'Vertical'
$txtOutput.ReadOnly = $true
$form.Controls.Add($txtOutput)

# Buttons: Generate and Cancel
$btnGenerate = New-Object System.Windows.Forms.Button
$btnGenerate.Location = New-Object System.Drawing.Point(620,14)
$btnGenerate.Size = New-Object System.Drawing.Size(130,30)
$btnGenerate.Text = "Generate"
$form.Controls.Add($btnGenerate)

$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Location = New-Object System.Drawing.Point(620,50)
$btnCancel.Size = New-Object System.Drawing.Size(130,30)
$btnCancel.Text = "Close"
$btnCancel.Add_Click({ $form.Close() })
$form.Controls.Add($btnCancel)

# Helper function to append to output and scroll
function Append-Output {
    param([string]$text)
    $txtOutput.AppendText("$text`r`n")
    Log $text
    Start-Sleep -Milliseconds 50
}

# Main generation routine
$btnGenerate.Add_Click({
    try {
        $Script:CancelRequested = $false
        $progress.Value = 0
        $txtOutput.Clear()

        $name = $txtName.Text.Trim()
        if ([string]::IsNullOrWhiteSpace($name)) {
            [System.Windows.Forms.MessageBox]::Show("Please provide a project folder name.","Missing Name",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        $basePath = $txtPath.Text.Trim()
        if (-not (Test-Path $basePath)) {
            $res = [System.Windows.Forms.MessageBox]::Show("Base path does not exist. Create it?","Create Path",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
            if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
                New-Item -ItemType Directory -Path $basePath -Force | Out-Null
                Append-Output "Created base path: $basePath"
            } else { return }
        }

        $projectPath = Join-Path -Path $basePath -ChildPath $name
        Append-Output "Target project path: $projectPath"

        if (Test-Path $projectPath) {
            $ok = Confirm-Overwrite -Path $projectPath
            if (-not $ok) { Append-Output "Cancelled by user - project exists."; return }
            Remove-Item -Recurse -Force -Path $projectPath
            Append-Output "Removed existing folder to recreate: $projectPath"
        }

        # Create main folder
        New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
        Append-Output "Created project folder"
        $progress.Value = 10

        # Create subfolders
        $folders = @('bin','config','docs','scripts','assets')
        $count = $folders.Count
        for ($i=0; $i -lt $count; $i++) {
            $f = Join-Path $projectPath $folders[$i]
            New-Item -ItemType Directory -Path $f -Force | Out-Null
            Append-Output "Created subfolder: $f"
            $progress.Value = 10 + [int](((($i+1)/$count) * 20))
            Start-Sleep -Milliseconds 120
        }

        # Create a sample README
        $readme = @"
# $name

This project was scaffolded by `cool-ps1-setup-generator.ps1`.

Folders included:
- bin: executable helpers
- config: configuration files (including configuration.bat)
- docs: documentation
- scripts: sample PowerShell scripts
- assets: images and other static files

Generated on: $(Get-Date -Format 'u')
"@
        SafeNew-Item -Path (Join-Path $projectPath 'README.md') -Content $readme
        Append-Output "Created README.md"
        $progress.Value = 40

        # Create configuration.bat if requested
        if ($chkBat.Checked) {
            $batPath = Join-Path $projectPath 'config\configuration.bat'
            $batContent = @"
@echo off
REM configuration.bat - Simple demo config
SET "PROJECT_NAME=%~1"
IF "%PROJECT_NAME%"=="" SET "PROJECT_NAME=$name"
ECHO Project Name: %PROJECT_NAME%
ECHO Setting up environment variables...
SETX COOL_PROJECT_NAME "%PROJECT_NAME%" >nul
ECHO Environment variable COOL_PROJECT_NAME set.
PAUSE
"@
            SafeNew-Item -Path $batPath -Content $batContent
            Append-Output "Created configuration.bat"
            $progress.Value = 50
        }

        # Create a sample PowerShell script in scripts\run.ps1
        $samplePs1 = @"
# sample run.ps1 - demonstrates reading config and writing to stdout
param(
    [string]`$Name = '$name'
)
`$log = Join-Path -Path (Split-Path -Parent `$MyInvocation.MyCommand.Path) '..\logs' -Resolve
if (-not (Test-Path `$log)) { New-Item -ItemType Directory -Path `$log -Force | Out-Null }
`$logFile = Join-Path `$log "run-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
"Hello from $name" | Out-File -FilePath `$logFile -Encoding utf8
Write-Output "Wrote runtime log to `$logFile"
"@
        SafeNew-Item -Path (Join-Path $projectPath 'scripts\run.ps1') -Content $samplePs1
        Append-Output "Created scripts\run.ps1"

        # Create .gitignore if requested
        if ($chkExtraFiles.Checked) {
            $gitignore = @"
# Default gitignore for generated project
bin/
config/
logs/
*.log
.env
"@
            SafeNew-Item -Path (Join-Path $projectPath '.gitignore') -Content $gitignore
            Append-Output "Created .gitignore"
            $progress.Value = 60

            # Create a sample LICENSE (MIT)
            $mit = @"
MIT License

Copyright (c) $(Get-Date -Format 'yyyy') $env:USERNAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
"@
            SafeNew-Item -Path (Join-Path $projectPath 'LICENSE.txt') -Content $mit
            Append-Output "Created LICENSE.txt"
        }

        # Create a configuration.json inside config
        $configObj = [PSCustomObject]@{
            project = $name
            created = (Get-Date).ToString('o')
            author = $env:USERNAME
            version = '0.1.0'
            settings = @{
                startOnBoot = $false
                enableFeatureX = $true
                maxItems = 42
            }
        }
        $configJson = $configObj | ConvertTo-Json -Depth 5
        SafeNew-Item -Path (Join-Path $projectPath 'config\configuration.json') -Content $configJson
        Append-Output "Wrote config/configuration.json"
        $progress.Value = 70

        # Create a small PowerShell helper that generates configuration.bat from JSON (demonstration)
        $psHelper = @"
# helper: make-bat-from-json.ps1
param(
    [string]`$ConfigFile = 'config\configuration.json'
)
if (-not (Test-Path `$ConfigFile)) { Write-Error "Config file not found: `$ConfigFile"; exit 1 }
`$c = Get-Content `$ConfigFile -Raw | ConvertFrom-Json
`$bat = "@echo off`r`nREM Auto-generated from JSON`r`nSET PROJECT_NAME=`"$(`$c.project)`"`r`nECHO Project: %PROJECT_NAME%"
`$out = Join-Path (Split-Path -Parent `$MyInvocation.MyCommand.Path) '..\config\configuration-from-json.bat'
Set-Content -Path `$out -Value `$bat -Force
Write-Output "Wrote `$out"
"@
        SafeNew-Item -Path (Join-Path $projectPath 'scripts\make-bat-from-json.ps1') -Content $psHelper
        Append-Output "Created scripts\make-bat-from-json.ps1"
        $progress.Value = 78

        # Create a sample asset (text file) in assets
        $assetText = "This is a sample asset. Replace with images or resources as you like."
        SafeNew-Item -Path (Join-Path $projectPath 'assets\sample-asset.txt') -Content $assetText
        Append-Output "Created sample asset"
        $progress.Value = 82

        # Create a logs folder and initial log
        New-Item -ItemType Directory -Path (Join-Path $projectPath 'logs') -Force | Out-Null
        SafeNew-Item -Path (Join-Path $projectPath 'logs\initial.log') -Content "Project created on: $(Get-Date -Format 'u')"
        Append-Output "Created logs and initial log"
        $progress.Value = 86

        # Optionally create desktop shortcut to open the folder
        if ($chkShortcut.Checked) {
            $desk = [Environment]::GetFolderPath('Desktop')
            $lnk = Join-Path $desk ("$name - Open.lnk")
            Create-Shortcut -TargetPath "explorer.exe" -ShortcutPath $lnk -Arguments "`"$projectPath`"" -WorkingDirectory $projectPath -Description "Open project folder: $name"
            Append-Output "Created Desktop shortcut"
            $progress.Value = 90
        }

        # Create a small HTML status page in docs
        $html = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$name Status</title>
</head>
<body>
<h1>$name</h1>
<p>Generated: $(Get-Date -Format 'u')</p>
<ul>
<li>Author: $env:USERNAME</li>
<li>Project path: $projectPath</li>
</ul>
</body>
</html>
"@
        SafeNew-Item -Path (Join-Path $projectPath 'docs\status.html') -Content $html
        Append-Output "Created docs/status.html"
        $progress.Value = 94

        # Finalizing
        Append-Output "Finalizing..."
        Start-Sleep -Milliseconds 350
        $progress.Value = 100

        [System.Windows.Forms.MessageBox]::Show("Project '$name' generated at:`n$projectPath","Done",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
        Append-Output "Generation complete."

        if ($chkLog.Checked) {
            Append-Output "Detailed log saved to: $Script:LogFile"
        } else {
            Append-Output "Logs were disabled by checkbox."
        }
    }
    catch {
        Append-Output "ERROR: $_"
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $_","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        Log "Generation failed: $_"
    }
})

# Add a small help button
$btnHelp = New-Object System.Windows.Forms.Button
$btnHelp.Location = New-Object System.Drawing.Point(620,90)
$btnHelp.Size = New-Object System.Drawing.Size(130,30)
$btnHelp.Text = "Help / About"
$btnHelp.Add_Click({
    $msg = @"
Cool PS1 Setup Generator

Author: Generated template
This GUI creates a scaffolded project folder with useful starter files.
Run Generate to create files. Use Browse to choose a base path.
"@
    [System.Windows.Forms.MessageBox]::Show($msg,"About",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
})
$form.Controls.Add($btnHelp)

# When form loads, ensure the log file exists
$form.Add_Load({
    if (-not (Test-Path $Script:LogFile)) { New-Item -ItemType File -Path $Script:LogFile -Force | Out-Null }
    Log "Started cool-ps1-setup-generator GUI"
})

# Show form
[void]$form.ShowDialog()

# End of script
Log "Exited cool-ps1-setup-generator.ps1"
