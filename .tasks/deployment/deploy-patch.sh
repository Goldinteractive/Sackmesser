#!/bin/bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
source "$CONFIG_FOLDER/deployment"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

ask "Deploy to $DEPLOY_DB_HOST ($DEPLOY_APPROOT)?"

if [ $? -ne 0 ]; then
    exit 1
fi

# remove dev files
rm -rf ./$COPY_DEST/$DEPLOY_DATA_FOLDER/*

# copy env files
cp -af $DEPLOYMENT_FOLDER/files/$DEPLOYENV/. "$COPY_DEST/"

rsync -azP -e "ssh -p $DEPLOY_PORT" $COPY_DEST/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current
