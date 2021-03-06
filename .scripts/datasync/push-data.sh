#!/usr/bin/env bash
set -e
source .config/build
source "$SCRIPTS_FOLDER/util.sh"
loadEnvConfig $DEPLOYENV

ask "Push files from localhost\nto $DEPLOY_HOST?"

if [ $? -ne 0 ]; then
    exit 1
fi

printf "$COLOR_GREEN""Upload files to $DEPLOY_APPROOT/$DEPLOY_DATA_FOLDER $COLOR_OFF \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_DATA_FOLDER/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/$DEPLOY_DATA_FOLDER/
if [ $? -ne 0 ]; then
    exit 1
fi