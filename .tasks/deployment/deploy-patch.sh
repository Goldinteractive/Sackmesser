#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

ask "Deploy to $DEPLOY_HOST ($DEPLOY_APPROOT)?"

if [ $? -ne 0 ]; then
    exit 1
fi

# prepare files and folders in dist
removeDevFilesFromDist
copyEnvFilesToDist

rsync -azP -e "ssh -p $DEPLOY_PORT" $COPY_DEST/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current