#!/usr/bin/env bash
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh

callRecipeEvent $RECIPE, "test"

exit 0