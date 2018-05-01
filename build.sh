#!/bin/bash

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Clean up the previous build
rm -rf $SCRIPTDIR/artifacts

VERSION=$(<$SCRIPTDIR/VERSION)

# Build for Windows, macOS and Linux
# Use linker flags for shrinking
GOOS=windows GOARCH=amd64 go build -v -o "$SCRIPTDIR/artifacts/serve_v${VERSION}_Windows_x64.exe" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=darwin GOARCH=amd64 go build -v -o "$SCRIPTDIR/artifacts/serve_v${VERSION}_macOS_x64" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=linux GOARCH=amd64 go build -v -o "$SCRIPTDIR/artifacts/serve_v${VERSION}_Linux_x64" -ldflags="-s -w" "github.com/philippgille/serve"

# Shrink binaries with UPX.
# Requires UPX to be installed (for example with "apt install upx-ucl").
upx --ultra-brute "$SCRIPTDIR/artifacts/serve_v${VERSION}_Windows_x64.exe"
upx --ultra-brute "$SCRIPTDIR/artifacts/serve_v${VERSION}_macOS_x64"
upx --ultra-brute "$SCRIPTDIR/artifacts/serve_v${VERSION}_Linux_x64"
