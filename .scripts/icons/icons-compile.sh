#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

# generate
php -f $SCRIPTS_FOLDER/icons/generate.php \
    sharedJson=$FE_SOURCE/shared-variables.json \
    iconsFolder=$ICONS_OUT \
    svgCombOutput=$ICONS_COMBINED_SVG
