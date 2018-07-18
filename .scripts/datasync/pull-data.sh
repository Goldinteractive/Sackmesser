#!/usr/bin/env bash
set -e
source .config/build
source "$SCRIPTS_FOLDER/util.sh"
loadEnvConfig $DEPLOYENV

ask "Pull files from $DEPLOY_HOST ($DEPLOY_APPROOT) to localhost?"

if [ $? -ne 0 ]; then
    exit 1
fi

# download files
for item in "${DEPLOY_DATA_FOLDERS[@]}"
do
    printf "$COLOR_GREEN""Download files from $DEPLOY_APPROOT/$item $COLOR_OFF \n"
    rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT"/$item/." $item/

    if [ $? -ne 0 ]; then
        exit 1
    fi
done