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

ask "Push files from localhost (DEPLOY_DATA_FOLDER)\nto $DEPLOY_HOST ($DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER)?"

if [ $? -ne 0 ]; then
    exit 1
fi

ask "Backup server files?" 0

if [ $? -eq 0 ]; then
    # backup files
    printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"

    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        cd $DEPLOY_APPROOT

        if [ -d "current/$DEPLOY_DATA_FOLDER" ]; then
            tar -cvzf "current/$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "current/$DEPLOY_DATA_FOLDER/../" "files"
            rm -rfv current/$DEPLOY_DATA_FOLDER/*
        else
            echo "Data folder does not exist. Continue."
        fi
EOF
fi

ZIP_FILENAME="deployment_files.tar"

printf "\033[0;32m ZIP local files \033[0m \n"
tar -cf  $ZIP_FILENAME -C "$DEPLOY_DATA_FOLDER/../" "files"

# upload files
printf "\033[0;32m Upload files to $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
scp -P $DEPLOY_PORT -r $ZIP_FILENAME $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT

if [ $? -ne 0 ]; then
    exit 1
fi

printf "\033[0;32m Unzip data \033[0m \n"
ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
     cd $DEPLOY_APPROOT
     tar -xf $ZIP_FILENAME -C "current/$DEPLOY_DATA_FOLDER/.."
EOF

#cleanup
rm -rf $ZIP_FILENAME
ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        rm -rf "$DEPLOY_APPROOT/$ZIP_FILENAME"
EOF