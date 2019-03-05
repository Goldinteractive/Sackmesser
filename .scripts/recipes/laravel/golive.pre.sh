#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

APPROOT=$DEPLOY_APPROOT

# setup environment
executeSSH "mkdir -p $APPROOT/_data/storage/app
    mkdir -p $APPROOT/_data/storage/framework/cache/data
    mkdir -p $APPROOT/_data/storage/framework/sessions
    mkdir -p $APPROOT/_data/storage/framework/testing
    mkdir -p $APPROOT/_data/storage/framework/views
    mkdir -p $APPROOT/_data/storage/logs"

# symlinks
executeSSH "ln -s ../../_data/storage $APPROOT/deploy/backend/storage"

# Replace the placeholder with the db pw for the environment
executeSSH "sed -i \"s/@DB_PASSWORD/$DB_PASSWORD/g\" $APPROOT/deploy/backend/config/database.php" > /dev/null

exit 0