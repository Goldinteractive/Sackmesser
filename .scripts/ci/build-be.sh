#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

# Install and build
ASSET_HASH=$ASSET_HASH \
CI_BUILD=1 \
    .scripts/backend/build.sh

exit 0