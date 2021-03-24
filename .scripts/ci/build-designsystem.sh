#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

STORYBOOK_DEST=$DEST/public/_designsystem

STORYBOOK_DEST=$STORYBOOK_DEST \
    .scripts/designsystem/build.sh

exit 0
