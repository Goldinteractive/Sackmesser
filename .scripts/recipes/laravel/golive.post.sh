#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

if [ $MIGRATE_DB -eq 1 ]; then
executeSSH "$DEPLOY_PHP_BINARY $DEPLOY_APPROOT/current/backend/artisan migrate;"
fi

exit 0