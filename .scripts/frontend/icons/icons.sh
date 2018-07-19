#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

# optimize icons

# in case there are already some icons we have to delete them before optimizing the new ones
rm -rf $ICONS_OUT
mkdir -p $ICONS_OUT
$SVGO -q --pretty --disable=removeViewBox --folder $ICONS_IN --output $ICONS_OUT

# generate
php -f $SCRIPTS_FOLDER/frontend/icons/generate.php \
    sharedJson=$FE_SOURCE/shared-variables.json \
    iconsFolder=$ICONS_OUT \
    dataFileOutput=$ICONS_DATA_FILE \
    svgCombOutput=$ICONS_COMBINED_SVG
