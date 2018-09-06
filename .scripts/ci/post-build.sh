#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

if [ "$RECIPE" == "craft" ] || [ "$RECIPE" == "laravel" ]
then
  egrep -lRZ "@ASSET_HASH" $DEST/$ASSET_HASH_TEMPLATE_REPLACE_PATH  | xargs --null sed -i "s/@ASSET_HASH/$ASSET_HASH/g"
fi

exit 0