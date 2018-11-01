#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

ln -s ../_data/uploads "$PUBLIC_DEST/uploads"

exit 0