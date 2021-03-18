#!/usr/bin/env bash
set -e
source .config/build

yarn run start-storybook -p 3002 --config-dir=$STORYBOOK_CONFIG_DIR
