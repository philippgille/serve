$ErrorActionPreference = "Stop"

docker run --rm -v ${PSScriptRoot}\..\:/build/serve -w /build/serve snapcraft/xenial-amd64 snapcraft

$version = Get-Content ${PSScriptRoot}\..\VERSION
Move-Item "${PSScriptRoot}\..\serve_${version}_amd64.snap" "${PSScriptRoot}\artifacts"
