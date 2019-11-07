#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

PUBLIC_DEST=$DEST/public

# Install and build
ASSET_HASH=$ASSET_HASH \
PUBLIC_DEST=$PUBLIC_DEST \
ENVIRONMENT=$ENV \
    .scripts/frontend/build.sh

# Package files
exit 0