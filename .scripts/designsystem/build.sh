#!/usr/bin/env bash
set -e
source .config/build

yarn build-storybook --config-dir=$STORYBOOK_CONFIG_DIR --quiet -o $STORYBOOK_DEST
