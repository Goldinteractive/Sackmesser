#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

# optimize icons

# in case there are already some icons we have to delete them before optimizing the new ones
rm -rf $ICONS_OUT
mkdir -p $ICONS_OUT

# svgo will fail if the folder does not contain any icons so we must check the folder contents
COUNT=$(ls -l $ICONS_IN | grep "\.svg$" | wc -l)
if [ $COUNT -gt 0 ]
then
  $SVGO -q --pretty --disable=removeViewBox --folder $ICONS_IN --output $ICONS_OUT
else
  # even if svgo did not copy anything we still want the empty icon files so that the app knows
  # there is nothing to load
  echo "no icons found"
fi

# generate
php -f $SCRIPTS_FOLDER/frontend/icons/generate.php \
    sharedJson=$FE_SOURCE/shared-variables.json \
    iconsFolder=$ICONS_OUT \
    dataFileOutput=$ICONS_DATA_FILE \
    svgCombOutput=$ICONS_COMBINED_SVG
