#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

ask "Pull files from $DEPLOY_HOST ($DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER)\nto localhost?"

if [ $? -ne 0 ]; then
    exit 1
fi

# backup files
backupDataFiles

# download files
for item in "${DEPLOY_DATA_FOLDERS[@]}"
do
    printf "$COLOR_GREEN""Download files from $DEPLOY_APPROOT/current/$item $COLOR_OFF \n"
    rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT"/current/$item/." $item/

    if [ $? -ne 0 ]; then
        exit 1
    fi
done