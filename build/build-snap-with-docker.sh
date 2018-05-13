#!/bin/bash

set -euxo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm -v ${SCRIPTDIR}/../:/build/serve -w /build/serve snapcraft/xenial-amd64 snapcraft
