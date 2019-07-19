# Script for building the serve binaries.
# 6 artifacts are built: A binary for Windows, macOS and Linux (all x64) and an archive of each.
#
# Example: ".\build.ps1"
# Example for building without UPX compression: ".\build.ps1 -noUpx"

param (
    [switch] $isAppVeyor,
    [switch] $noUpx
)

$ErrorActionPreference = "Stop"

$artifactsDir = "${PSScriptRoot}\artifacts"
$version = Get-Content ${PSScriptRoot}\..\VERSION

# Clean up the previous build
If (Test-Path "${artifactsDir}") {Remove-Item -Recurse -Force "${artifactsDir}"}

# Build for Windows, macOS and Linux.
# Use linker flags for shrinking.

# Save current GOARCH for resetting it later, because PowerShell doesn't support temporary environment variables per command like Bash
$go_arch_backup = go env GOARCH
$env:GOARCH = "amd64"
# Write-Output because PowerShell doesn't have an equivalent to "set -x" to print the executed commands like Bash
Write-Output "Building binary for Windows"
$env:GOOS = "windows"
go build -v -o "${artifactsDir}\serve_v${version}_Windows_x64\serve.exe" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Building binary for macOS"
$env:GOOS = "darwin"
# Sleep and "go build" to prevent "internal/race" and other errors on AppVeyor
if ($isAppVeyor)
{
    Start-Sleep -s 5
    go build
    Start-Sleep -s 5
}
go build -v -o "${artifactsDir}\serve_v${version}_macOS_x64\serve" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Building binary for Linux"
$env:GOOS = "linux"
if ($isAppVeyor)
{
    Start-Sleep -s 5
    go build
    Start-Sleep -s 5
}
go build -v -o "${artifactsDir}\serve_v${version}_Linux_x64\serve" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Finished building binaries"
# Reset
$env:GOOS = "windows"
$env:GOARCH = $go_arch_backup

# Shrink binaries with UPX.
# Requires UPX to be installed (for example with "choco install upx" or "scoop install upx").
if (!$noUpx.IsPresent)
{
    upx --ultra-brute "${artifactsDir}\serve_v${version}_Windows_x64\serve.exe"
    # Leads to a broken executable when using UPX v3.95. See https://github.com/upx/upx/issues/222.
    #upx --ultra-brute "${artifactsDir}\serve_v${version}_macOS_x64\serve"
    upx --ultra-brute "${artifactsDir}\serve_v${version}_Linux_x64\serve"
}

# Create an archive for each of the "serve" binaries, so when users extract the archive, they don't have to rename it
$archiveDirs = "${artifactsDir}\serve_v${version}_Windows_x64",
    "${artifactsDir}\serve_v${version}_macOS_x64",
    "${artifactsDir}\serve_v${version}_Linux_x64"
foreach ($archiveDir in $archiveDirs) {
    # Note: On some systems with the full .NET Framework the assembly must first be added.
    # But the command doesn't work in nanoserver for example, where it also isn't necessary at all.
    # So only execute it if the assembly isn't already loaded.
    try {
        [io.compression.zipfile]::CreateFromDirectory("$archiveDir", "$archiveDir.zip")
        # Sleep to prevent: Exception calling "CreateFromDirectory" with "2" argument(s): "The file '..._macOS_x64.zip' already exists."
        Start-Sleep -s 1
    }
    catch {
        Add-Type -Assembly "System.IO.Compression.FileSystem"
        [io.compression.zipfile]::CreateFromDirectory("$archiveDir", "$archiveDir.zip")
        Start-Sleep -s 1
    }
}

# Also copy and rename the original files to have bare binaries
Copy-Item "${artifactsDir}\serve_v${version}_Windows_x64\serve.exe" "${artifactsDir}\serve_v${version}_Windows_x64.exe"
Remove-Item -Recurse -Force "${artifactsDir}\serve_v${version}_Windows_x64"
Copy-Item "${artifactsDir}\serve_v${version}_macOS_x64\serve" "${artifactsDir}\serve"
Remove-Item -Recurse -Force "${artifactsDir}\serve_v${version}_macOS_x64"
Rename-Item "${artifactsDir}\serve" "${artifactsDir}\serve_v${version}_macOS_x64"
Copy-Item "${artifactsDir}\serve_v${version}_Linux_x64\serve" "${artifactsDir}\serve"
Remove-Item -Recurse -Force "${artifactsDir}\serve_v${version}_Linux_x64"
Rename-Item "${artifactsDir}\serve" "${artifactsDir}\serve_v${version}_Linux_x64"

# Generate hashes and save as file.
# Archives
(Get-FileHash "${artifactsDir}\serve_v${version}_Windows_x64.exe").Hash | Out-File "${artifactsDir}\serve_v${version}_Windows_x64.exe.sha256" -NoNewline
(Get-FileHash "${artifactsDir}\serve_v${version}_macOS_x64").Hash | Out-File "${artifactsDir}\serve_v${version}_macOS_x64.sha256" -NoNewline
(Get-FileHash "${artifactsDir}\serve_v${version}_Linux_x64").Hash | Out-File "${artifactsDir}\serve_v${version}_Linux_x64.sha256" -NoNewline
# Binaries
(Get-FileHash "${artifactsDir}\serve_v${version}_Windows_x64.zip").Hash | Out-File "${artifactsDir}\serve_v${version}_Windows_x64.zip.sha256" -NoNewline
(Get-FileHash "${artifactsDir}\serve_v${version}_macOS_x64.zip").Hash | Out-File "${artifactsDir}\serve_v${version}_macOS_x64.zip.sha256" -NoNewline
(Get-FileHash "${artifactsDir}\serve_v${version}_Linux_x64.zip").Hash | Out-File "${artifactsDir}\serve_v${version}_Linux_x64.zip.sha256" -NoNewline
