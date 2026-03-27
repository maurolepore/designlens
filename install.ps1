# designlog Windows Installer

param(
    [string]$InstallDir = "$env:LOCALAPPDATA\designlog"
)

Write-Host "Installing designlog for Windows..."

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Create installation directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Write-Host "Created installation directory: $InstallDir"
}

# Copy directories
Write-Host "Copying files..."
Copy-Item -Path "$ScriptDir\bin" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\lib" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\docs" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\README.md" -Destination "$InstallDir\" -Force

# Make scripts executable (Git Bash requirement)
Write-Host "Making scripts executable for Git Bash..."
$scripts = Get-ChildItem -Path "$InstallDir\lib" -Filter "*.sh"
foreach ($script in $scripts) {
    icacls $script.FullName /grant:r "$env:USERNAME`:(F)" | Out-Null
}

# Add to PATH if not already there
$path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($path -notlike "*$InstallDir*") {
    Write-Host "Adding to user PATH..."
    $newPath = "$path;$InstallDir\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host ""
Write-Host "✓ designlog installed successfully!"
Write-Host "Installation directory: $InstallDir"
Write-Host ""
Write-Host "IMPORTANT: designlog requires Git Bash (comes with Git for Windows)."
Write-Host "Run commands in Git Bash or WSL, not in cmd.exe or PowerShell."
Write-Host ""
Write-Host "To get started:"
Write-Host "  1. Open Git Bash in your project directory"
Write-Host "  2. Run: designlog init"
