#!/bin/bash

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

printf "Enter the SSH password for user ($DEPLOY_USER)\n"

ssh-copy-id $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT