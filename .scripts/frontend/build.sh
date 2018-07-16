#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

# expects $ASSET_HASH, $PUBLIC_DEST, $ENVIRONMENT
$SCRIPTS_FOLDER/frontend/install.sh

WEBPACK_MODE=production \
ASSET_HASH=$ASSET_HASH \
PUBLIC_DEST=$PUBLIC_DEST \
ENVIRONMENT=$ENVIRONMENT \
.scripts/frontend/webpack.sh