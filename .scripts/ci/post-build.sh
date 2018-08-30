#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

egrep -lRZ "@ASSET_HASH" $ASSET_HASH_TEMPLATE_REPLACE_PATH  | xargs --null sed -i "s/@ASSET_HASH/$ASSET_HASH/g"

exit 0