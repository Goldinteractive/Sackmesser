#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

# copy env files to dest
ENVFILES=$DEPLOYMENT_FOLDER/files/$ENV
if [ -d "$ENVFILES" ]
then
    cp -af $ENVFILES/. "$DEST/"
fi

/bin/drone-scp --host "$DEPLOY_HOST" \
    --port "$DEPLOY_PORT" \
    --username "$DEPLOY_USER" \
    --target "$DEPLOY_APPROOT/deploy" \
    --source "$DEST/*" \
    --strip.components "1" \
    --rm true

exit 0