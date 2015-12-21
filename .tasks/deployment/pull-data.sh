#!/bin/bash

source "$CONFIG_FOLDER/deployment"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE


DB_DATA_PULL_FILE="db_data_pull_file.sql"

# backup files
printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"
tar -cvzf "$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "$DEPLOY_DATA_FOLDER/../" "files"
rm -rf $DEPLOY_DATA_FOLDER/*

# get files
printf "\033[0;32m Download files from $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT"/current/$DEPLOY_DATA_FOLDER/." $DEPLOY_DATA_FOLDER/

if [ $? -ne 0 ]; then
    exit 1
fi
