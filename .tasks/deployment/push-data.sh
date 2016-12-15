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

# backup files
printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"

  ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        cd $DEPLOY_APPROOT

        if [ -d "current/$DEPLOY_DATA_FOLDER" ]; then
            tar -cvzf "current/$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "current/$DEPLOY_DATA_FOLDER/../" "files"
        else
            echo "Data folder does not exist. Continue."
        fi
EOF

# upload files
printf "\033[0;32m Upload files to $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_DATA_FOLDER/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER/

if [ $? -ne 0 ]; then
    exit 1
fi
