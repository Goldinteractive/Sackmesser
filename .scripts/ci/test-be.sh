#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

.scripts/backend/test.sh