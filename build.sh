#!/bin/bash

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Clean up the previous build
rm -rf $SCRIPTDIR/artifacts

# Build for Windows, macOS and Linux
# Use linker flags for shrinking
GOOS=windows go build -o "$SCRIPTDIR/artifacts/serve_Windows_x64.exe" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=darwin go build -o "$SCRIPTDIR/artifacts/serve_macOS_x64" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=linux go build -o "$SCRIPTDIR/artifacts/serve_Linux_x64" -ldflags="-s -w" "github.com/philippgille/serve"
