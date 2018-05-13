$ErrorActionPreference = "Stop"

docker run --rm -v ${PSScriptRoot}\..\:/build/serve -w /build/serve snapcraft/xenial-amd64 snapcraft
