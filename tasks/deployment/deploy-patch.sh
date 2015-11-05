#!/bin/bash

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

rsync -azP $COPY_DEST/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current