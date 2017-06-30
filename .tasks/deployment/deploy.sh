#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

CURRENTREV=$(getCurrentRev)
OLDREV=$(getOldRev)
CURRENTREVFOLDER=$(getCurrentRevFolder)
OLDREVFOLDER=$(getOldRevFolder)

ask "Deploy to $DEPLOY_HOST ($DEPLOY_APPROOT)?"

if [ $? -ne 0 ]; then
    exit 1
fi

# copy specific .env file to dist
cp ".env.$DEPLOYENV" $COPY_DEST/.env

# prepare files and folders in dist
removeDevFilesFromDist
copyEnvFilesToDist
copyDeploymentFolderToDist

# prepare dist folder for deployment
printf "$COLOR_GREEN""Prepare dist folder for deployment.$COLOR_OFF\n"
mv "$COPY_DEST" "$CURRENTREVFOLDER"

ARCHIVEFILENAME="rev$CURRENTREV.tar.gz"
tar --exclude="$ARCHIVEFILENAME" -cvzf "$CURRENTREVFOLDER/$ARCHIVEFILENAME" -C "$CURRENTREVFOLDER/../" $CURRENTREVFOLDER

mv "$CURRENTREVFOLDER" "$COPY_DEST"

printf "$COLOR_GREEN""Upload our archive to the server.$COLOR_OFF\n"
scp -P $DEPLOY_PORT "$COPY_DEST/$ARCHIVEFILENAME" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT

if [ $? -eq 1 ]; then
    exit 1
fi

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT "bash -s" << EOF
    cd $DEPLOY_APPROOT

    if [ -d "$CURRENTREVFOLDER" ]; then
        rm -rf "$CURRENTREVFOLDER"
    fi

    tar -zxvf $ARCHIVEFILENAME
    rm $ARCHIVEFILENAME

    if [ $CURRENTREV -gt 1 ]; then
        if [ $BACKUP_DB -eq 1 ]; then
            mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > "$CURRENTREVFOLDER/.deployment/database/backup/backup.sql"
        fi
    fi
EOF

for item in "${DEPLOY_DATA_FOLDERS[@]}"
do
  printf "$COLOR_GREEN""Copy data ($item) from current to $CURRENTREVFOLDER $COLOR_OFF \n"
  ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT "bash -s" << EOF
    cd $DEPLOY_APPROOT
    if [ -d "current/$item" ]; then
        cp -af "current/$item/." "$CURRENTREVFOLDER/$item/"
    fi
EOF
done

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT "bash -s" << EOF
   cd $DEPLOY_APPROOT
    if [ -d "current" ]; then
        if [ -d $OLDREVFOLDER ]; then
            rm -rf $OLDREVFOLDER
        fi

        mv "current" "$OLDREVFOLDER"
    fi

    mv "$CURRENTREVFOLDER" "current"
EOF

if [ $? -ne 0 ]; then
    exit 1
fi