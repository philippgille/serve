param (
    [switch] $isAppVeyor
)

$ErrorActionPreference = "Stop"

# Clean up the previous build
If (Test-Path "${PSScriptRoot}\artifacts") {Remove-Item -Recurse -Force "${PSScriptRoot}\artifacts"}

$version = Get-Content ${PSScriptRoot}\VERSION

# Build for Windows, macOS and Linux.
# Use linker flags for shrinking.

# Save current GOARCH for resetting it later, because PowerShell doesn't support temporary environment variables per command like Bash
$go_arch_backup = go env GOARCH
$env:GOARCH = "amd64"
# Write-Output because PowerShell doesn't have an equivalent to "set -x" to print the executed commands like Bash
Write-Output "Building binary for Windows"
$env:GOOS = "windows"
go build -v -o "${PSScriptRoot}\artifacts\serve_v${version}_Windows_x64.exe" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Building binary for macOS"
$env:GOOS = "darwin"
# Sleep and "go build" to prevent "internal/race" and other errors on AppVeyor
if ($isAppVeyor)
{
    Start-Sleep -s 5
    go build
    Start-Sleep -s 5
}
go build -v -o "${PSScriptRoot}\artifacts\serve_v${version}_macOS_x64" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Building binary for Linux"
$env:GOOS = "linux"
if ($isAppVeyor)
{
    Start-Sleep -s 5
    go build
    Start-Sleep -s 5
}
go build -v -o "${PSScriptRoot}\artifacts\serve_v${version}_Linux_x64" -ldflags="-s -w" "github.com/philippgille/serve"
Write-Output "Finished building binaries"
# Reset
$env:GOOS = "windows"
$env:GOARCH = $go_arch_backup

# Shrink binaries with UPX.
# Requires UPX to be installed (for example with "choco install upx" or "scoop install upx").
upx --ultra-brute "${PSScriptRoot}\artifacts\serve_v${version}_Windows_x64.exe"
upx --ultra-brute "${PSScriptRoot}\artifacts\serve_v${version}_macOS_x64"
upx --ultra-brute "${PSScriptRoot}\artifacts\serve_v${version}_Linux_x64"
