#!/usr/bin/env bash
set -e
source .config/build

if [ "$RECIPE" == "craft" ]
then
    ln -s ../_data/files "$PUBLIC_DEST/files"
fi

exit 0