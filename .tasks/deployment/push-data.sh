#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

ask "Push files from localhost\nto $DEPLOY_HOST?"

if [ $? -ne 0 ]; then
    exit 1
fi

for item in "${DEPLOY_DATA_FOLDERS[@]}"
do
    printf "$COLOR_GREEN""Backup files in $item $COLOR_OFF \n"

    FOLDERNAME=$(basename $item)
    FILENAME="backup_${item//\//_}.tar.gz"

    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        cd $DEPLOY_APPROOT

        if [ -d "current/$item" ]; then
            tar -cvzf "current/$DEPLOY_DATA_BACKUP_FOLDER/$FILENAME" -C "current/$item/../" $FOLDERNAME
        else
            echo "Data folder current/$item does not exist. Skip backup."
        fi

        if [ $? -ne 0 ]; then
            exit 1
        fi
EOF

printf "$COLOR_GREEN""Upload files to $DEPLOY_APPROOT/current/$item $COLOR_OFF \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $item/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current/$item/

if [ $? -ne 0 ]; then
    exit 1
fi
done