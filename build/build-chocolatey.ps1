# Builds the Chocolatey package if the Windows x64 binary exists.
# Uses an installed version of Chocolatey.

$ErrorActionPreference = "Stop"

$version = Get-Content ${PSScriptRoot}\..\VERSION
$artifactsDir = "$PSScriptRoot\artifacts"

If (Test-Path "$artifactsDir\serve_v${version}_Windows_x64.exe")
{
    # Create and clean directories
    mkdir "$PSScriptRoot\..\chocolatey\tools" -Force
    Remove-Item -Force "$artifactsDir\serve.*.nupkg"
    Remove-Item -Force "$PSScriptRoot\..\chocolatey\tools\*"
    # Copy SCD files
    Copy-Item "$artifactsDir\serve_v${version}_Windows_x64.exe" "$PSScriptRoot\..\chocolatey\tools\serve.exe"
    # Build Chocolatey package
    choco pack "$PSScriptRoot\..\chocolatey\serve.portable.nuspec" --out $artifactsDir
    choco pack "$PSScriptRoot\..\chocolatey\serve.nuspec" --out $artifactsDir
}
