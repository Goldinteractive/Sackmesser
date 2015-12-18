#!/bin/bash

source "$CONFIG_FOLDER/deployment"

REV_FILE=$DEPLOYMENT_FOLDER/rev
CURRENTREV=$(cat $REV_FILE)
OLDREV=$(($CURRENTREV-1))
OLDREV_FOLDER="rev$OLDREV"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
    cd $DEPLOY_APPROOT

    mv $OLDREV_FOLDER "tmprev"
    rm -rf rev*
    mv "tmprev" $OLDREV_FOLDER
EOF