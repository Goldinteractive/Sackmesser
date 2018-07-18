#!/usr/bin/env bash
set -e
source .config/build
source "$SCRIPTS_FOLDER/util.sh"
loadEnvConfig $DEPLOYENV

ask "Push files from localhost\nto $DEPLOY_HOST?"

if [ $? -ne 0 ]; then
    exit 1
fi

for item in "${DEPLOY_DATA_FOLDERS[@]}"
do

printf "$COLOR_GREEN""Upload files to $DEPLOY_APPROOT/$item $COLOR_OFF \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $item/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/$item/

if [ $? -ne 0 ]; then
    exit 1
fi
done