#!/usr/bin/env bash
set -e
source .config/build

if [ "$RECIPE" == "craft" ]
then
    ln -s ../_data/uploads "$PUBLIC_DEST/uploads"
fi

exit 0