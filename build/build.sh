#!/bin/bash

# Script for building the serve binaries.
# 6 artifacts are built: A binary for Windows, macOS and Linux (all x64) and an archive of each.
#
# Example: "./build.sh"
# Example for building without UPX compression: "./build.sh noupx"

set -euxo pipefail

# Parameters
if [[ $# -eq 1 && "$1" == "noupx" ]]; then
    NO_UPX=true
else
    NO_UPX=false
fi

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ARTIFACTSDIR="$SCRIPTDIR/artifacts"
VERSION=$(<$SCRIPTDIR/../VERSION)

# Clean up the previous build
rm -rf ${ARTIFACTSDIR}

# Build for Windows, macOS and Linux
# Use linker flags for shrinking
GOOS=windows GOARCH=amd64 go build -v -o "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64/serve.exe" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=darwin GOARCH=amd64 go build -v -o "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64/serve" -ldflags="-s -w" "github.com/philippgille/serve"
GOOS=linux GOARCH=amd64 go build -v -o "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64/serve" -ldflags="-s -w" "github.com/philippgille/serve"

# Shrink binaries with UPX.
# Requires UPX to be installed (for example with "apt install upx-ucl").
if [[ "$NO_UPX" == "false" ]]; then
    upx --ultra-brute "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64/serve.exe"
    # Leads to a broken executable when using UPX v3.95. See https://github.com/upx/upx/issues/222.
    #upx --ultra-brute "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64/serve"
    upx --ultra-brute "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64/serve"
fi

# Create an archive for each of the "serve" binaries, so when users extract the archive, they don't have to rename it
declare -a arr=("Windows" "macOS" "Linux")
for MYOS in "${arr[@]}"
do
    # Sleep to prevent: tar: serve_v0.3.2_macOS_x64: file changed as we read it
    sleep 1s
    tar -czf "${ARTIFACTSDIR}/serve_v${VERSION}_${MYOS}_x64.tar.gz" -C "${ARTIFACTSDIR}" "serve_v${VERSION}_${MYOS}_x64"
done

# Also copy and rename the original files to have bare binaries
cp "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64/serve.exe" "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64.exe"
rm -rf "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64"
cp "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64/serve" "${ARTIFACTSDIR}/serve"
rm -rf "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64"
mv "${ARTIFACTSDIR}/serve" "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64"
cp "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64/serve" "${ARTIFACTSDIR}/serve"
rm -rf "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64"
mv "${ARTIFACTSDIR}/serve" "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64"

# Generate hashes and save as file.
# Archives
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64.tar.gz" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64.tar.gz.sha256"
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64.tar.gz" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64.tar.gz.sha256"
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64.tar.gz" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64.tar.gz.sha256"
# Binaries
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64.exe" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_Windows_x64.exe.sha256"
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_macOS_x64.sha256"
echo -n $(sha256sum "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64" | cut -d " " -f 1) > "${ARTIFACTSDIR}/serve_v${VERSION}_Linux_x64.sha256"
