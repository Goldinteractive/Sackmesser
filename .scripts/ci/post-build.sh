#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

# replace @ASSET_HASH in files of the following folder
if [ ! -z $ASSET_HASH_TEMPLATE_REPLACE_PATH ]; then
    egrep -lRZ "@ASSET_HASH" $DEST/$ASSET_HASH_TEMPLATE_REPLACE_PATH | xargs --null sed -i "s/@ASSET_HASH/$ASSET_HASH/g"
fi

callRecipeEvent $RECIPE "build.post"

exit 0