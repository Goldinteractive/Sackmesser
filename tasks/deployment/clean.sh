#!/bin/bash

source "$CONFIG_FOLDER/deployment"

REV_FILE=$DEPLOYMENT_FOLDER/rev
CURRENTREV=$(cat $REV_FILE)

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE