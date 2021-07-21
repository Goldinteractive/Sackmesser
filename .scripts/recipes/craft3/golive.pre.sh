#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

APPROOT=$DEPLOY_APPROOT

# symlinks
executeSSH "ln -s ../../_data/storage $APPROOT/deploy/backend/storage"

# Replace the placeholder with the db pw for the environment
executeSSH "sed -i \"s/@DB_PASSWORD/$DB_PASSWORD/g\" $APPROOT/deploy/backend/config/db.php" > /dev/null
executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft migrate/all"
executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft project-config/apply"
executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft blitz/cache/clear"
executeSSH "APPENV=$ENV $DEPLOY_PHP_BINARY $APPROOT/deploy/backend/craft crafter/cache/clear-template"
