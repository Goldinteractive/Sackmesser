#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

ask "Pull files from $DEPLOY_HOST ($DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER)\nto localhost?"
if [ $? -ne 0 ]; then
    exit 1
fi

ask "Backup local files?" 0
if [ $? -eq 0 ]; then
    backupDataFiles
fi

#zip files on server
for item in "${DEPLOY_DATA_FOLDERS[@]}"
do
    FILENAME="deployment_${item//\//_}.tar.gz"
    FOLDERNAME=$(basename $item)

    printf "$COLOR_GREEN""Zip files on server ($item) $COLOR_OFF \n"
    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF

    if [ -d "$DEPLOY_APPROOT/current/$item" ]; then
        tar -czf  "$DEPLOY_APPROOT/$FILENAME" -C "$DEPLOY_APPROOT/current/$item/../" $FOLDERNAME
        exit 0
    else
        printf "$COLOR_RED""Folder not found ($item). Skip. $COLOR_OFF \n"
        exit 1
    fi
EOF
    if [ $? -eq 0 ]; then
        printf "$COLOR_GREEN""Clean local data folder ($item) $COLOR_OFF \n"
        rm -rf $item/*

        # get files
        printf "$COLOR_GREEN""Download files from $DEPLOY_APPROOT/current/$item $COLOR_OFF \n"
        rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:"$DEPLOY_APPROOT/$FILENAME" $FILENAME

        if [ $? -ne 0 ]; then
            exit 1
        fi

         tar -xf $FILENAME -C $item/..

        # cleanup
        rm -rf $FILENAME
        ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
                rm -rf "$DEPLOY_APPROOT/$FILENAME"
EOF
    fi
done