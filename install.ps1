# designlens Windows Installer

param(
    [string]$InstallDir = "$env:LOCALAPPDATA\designlens"
)

$Repo   = "ropensci-review-tools/designlens"
$Branch = "main"
$ArchiveUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"

Write-Host "Installing designlens for Windows..."

# Download archive to a temp directory
Write-Host "Downloading designlens..."
$TmpDir = Join-Path $env:TEMP ("designlens-install-" + [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

$ZipPath = Join-Path $TmpDir "designlens.zip"
Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ZipPath
Expand-Archive -Path $ZipPath -DestinationPath $TmpDir

# GitHub zip extracts to a subfolder named <repo>-<branch>
$ScriptDir = Join-Path $TmpDir ("designlens-" + $Branch)

# Create installation directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Write-Host "Created installation directory: $InstallDir"
}

# Copy directories and metadata
Write-Host "Copying files..."
Copy-Item -Path "$ScriptDir\bin" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\lib" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\docs" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\commands" -Destination "$InstallDir\" -Recurse -Force
Copy-Item -Path "$ScriptDir\README.md" -Destination "$InstallDir\" -Force
Copy-Item -Path "$ScriptDir\designlens.json" -Destination "$InstallDir\" -Force
Copy-Item -Path "$ScriptDir\LICENSE" -Destination "$InstallDir\" -Force

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

# Clean up temp directory
Remove-Item -Recurse -Force $TmpDir

Write-Host ""
Write-Host "✓ designlens installed successfully!"
Write-Host "Installation directory: $InstallDir"
Write-Host ""
Write-Host "IMPORTANT: designlens requires Git Bash (comes with Git for Windows)."
Write-Host "Run commands in Git Bash or WSL, not in cmd.exe or PowerShell."
Write-Host ""
Write-Host "To get started:"
Write-Host "  1. Open Git Bash in your project directory"
Write-Host "  2. Run: designlens init"
