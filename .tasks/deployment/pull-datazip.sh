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

ask "Pull files from $DEPLOY_HOST ($DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER)\nto localhost ($DEPLOY_DATA_FOLDER)?"

if [ $? -ne 0 ]; then
    exit 1
fi

ask "Backup local files?" 0

if [ $? -eq 0 ]; then
    # backup files
    printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"
    if [ -d "$DEPLOY_DATA_FOLDER" ]; then
        tar -cvzf "$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "$DEPLOY_DATA_FOLDER/../" "files"
    fi
fi

ZIP_FILENAME="deployment_files.tar.gz"

 zip files on server
 printf "\033[0;32m ZIP Files on server \033[0m \n"
    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
         tar -czf  "$DEPLOY_APPROOT/$ZIP_FILENAME" -C "$DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER/../" "files"
EOF

if [ $? -ne 0 ]; then
    exit 1
fi

printf "\033[0;32m Clean local data folder \033[0m \n"
rm -rf $DEPLOY_DATA_FOLDER/*

# get files
printf "\033[0;32m Download files from $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:"$DEPLOY_APPROOT/$ZIP_FILENAME" $ZIP_FILENAME

if [ $? -ne 0 ]; then
    exit 1
fi

tar -xf $ZIP_FILENAME -C $DEPLOY_DATA_FOLDER/..

# cleanup
rm -rf $ZIP_FILENAME
ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        rm -rf "$DEPLOY_APPROOT/$ZIP_FILENAME"
EOF