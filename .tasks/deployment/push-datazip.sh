#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

ask "Push files from localhost (DEPLOY_DATA_FOLDER)\nto $DEPLOY_HOST?"
if [ $? -ne 0 ]; then
    exit 1
fi

ask "Backup server files? " 0
if [ $? -eq 0 ]; then
    # backup files
    for item in "${DEPLOY_DATA_FOLDERS[@]}"
    do
        printf "$COLOR_GREEN""Backup files in $item $COLOR_OFF \n"

        FILENAME="deployment_${item//\//_}.tar.gz"
        FOLDERNAME=$(basename $item)

        ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        cd $DEPLOY_APPROOT

        if [ -d "current/$item" ]; then
            tar -cvzf "current/$DEPLOY_DATA_BACKUP_FOLDER/$FILENAME" -C "current/$item/../" $FOLDERNAME
            exit 0
        else
            printf "$COLOR_RED""Folder not found ($item). Skip. $COLOR_OFF \n"
            exit 1
        fi
EOF
         if [ $? -eq 0 ]; then
          printf "$COLOR_GREEN""ZIP local files $COLOR_OFF \n"

            FILENAME="deployment_${item//\//_}.tar.gz"
            FOLDERNAME=$(basename $item)

            tar -cf  $FILENAME -C "$item/../" $FOLDERNAME

            # upload files
            printf "$COLOR_GREEN""Upload files to $DEPLOY_APPROOT/current/$item $COLOR_OFF \n"
            scp -P $DEPLOY_PORT -r $FILENAME $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT

            if [ $? -ne 0 ]; then
                exit 1
            fi

            printf "$COLOR_GREEN""Unzip data $COLOR_OFF \n"
            ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
                 cd $DEPLOY_APPROOT
                 rm -rf "current/$item/*"
                 tar -xf $FILENAME -C "current/$item/.."
EOF
            #cleanup
            rm -rf $FILENAME
            ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
                rm -rf "$DEPLOY_APPROOT/$FILENAME"
EOF
        fi
    done
fi
