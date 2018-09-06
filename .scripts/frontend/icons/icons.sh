#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

# optimize icons

# in case there are already some icons we have to delete them before optimizing the new ones
rm -rf $ICONS_OUT
mkdir -p $ICONS_OUT

FILES=$(find $ICONS_IN -maxdepth 1 -name "*.svg")
for FULL_FILE_PATH in $FILES; do
  # filename with extension - but without path
  FILENAME="${FULL_FILE_PATH##*/}"
  # filename without extension
  NAME="${FILENAME%.*}"

  # the prefix must be set per file because they will afterwards be merged into a single svg
  $SVGO -q --pretty --disable=removeViewBox --input $FULL_FILE_PATH --output $ICONS_OUT \
    --config '{"plugins": [{"cleanupIDs": { "prefix": "'"$NAME"'-" }}] }'
done

# generate
php -f $SCRIPTS_FOLDER/frontend/icons/generate.php \
    sharedJson=$FE_SOURCE/shared-variables.json \
    iconsFolder=$ICONS_OUT \
    dataFileOutput=$ICONS_DATA_FILE \
    svgCombOutput=$ICONS_COMBINED_SVG
