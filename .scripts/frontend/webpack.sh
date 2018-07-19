#!/usr/bin/env bash
set -e

source .config/build

#expects $WEBPACK_MODE, $ASSET_HASH, $PUBLIC_DEST, $ENVIRONMENT
$SCRIPTS_FOLDER/frontend/icons/icons.sh

$SCRIPTS_FOLDER/frontend/favicons.sh $FAVICONS_IN $FAVICONS_OUT

# clear the directory
if [ -d "$PUBLIC_DEST" ]
then
  rm -rf $PUBLIC_DEST/*
fi

# For the dev environment we want to create a link to the uploaded files
if [ $WEBPACK_MODE == "development" ]
then
  mkdir -p $PUBLIC_DEST
  PUBLIC_DEST=$PUBLIC_DEST \
    .scripts/frontend/link-dev-data.sh
fi

$WEBPACK --mode $WEBPACK_MODE \
  --config $WEBPACK_CONFIG \
  --env.assetHash $ASSET_HASH \
  --env.environment $ENVIRONMENT \
  --env.publicDest $PUBLIC_DEST \
  --env.mode $WEBPACK_MODE
