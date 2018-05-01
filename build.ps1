$ErrorActionPreference = "Stop"

# Clean up the previous build
If (Test-Path "${PSScriptRoot}\artifacts") {Remove-Item -Recurse -Force "${PSScriptRoot}\artifacts"}

# Build for Windows, macOS and Linux
# Use linker flags for shrinking
Set-Variable GOOS=linux
go build -o "${PSScriptRoot}\artifacts\serve_Windows_x64.exe" -ldflags="-s -w" "github.com/philippgille/serve"
Set-Variable GOOS=linux
go build -o "${PSScriptRoot}\artifacts\serve_macOS_x64" -ldflags="-s -w" "github.com/philippgille/serve"
Set-Variable GOOS=linux
go build -o ${PSScriptRoot}\"artifacts\serve_Linux_x64" -ldflags="-s -w" "github.com/philippgille/serve"
