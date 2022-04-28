#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

APPROOT=$DEPLOY_APPROOT

executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft blitz/cache/clear"
executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft crafter/cache/clear-template"
