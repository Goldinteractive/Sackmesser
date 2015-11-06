#!/bin/bash

source "$CONFIG_FOLDER/deployment"

REV_FILE=$DEPLOYMENT_FOLDER/rev
CURRENTREV=$(cat $REV_FILE)
OLDREV=$(($CURRENTREV-1))
REV_FOLDER="rev$CURRENTREV"
OLDREV_FOLDER="rev$OLDREV"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

#htaccess stuff
rm "$COPY_DEST/$WEBROOT_PATH/.htaccess"
mv "$COPY_DEST/$WEBROOT_PATH/.htaccess.$DEPLOYENV" "$COPY_DEST/$WEBROOT_PATH/.htaccess"
rm $COPY_DEST/$WEBROOT_PATH/.htaccess.*

mv "$COPY_DEST" "$REV_FOLDER"

archiveFileName="rev$CURRENTREV.tar.gz"
tar --exclude="$archiveFileName" -cvzf "$REV_FOLDER/$archiveFileName" -C "$REV_FOLDER/../" $REV_FOLDER

mv "$REV_FOLDER" "$COPY_DEST"

printf "No we want to upload our archive to the server.\n"

scp "$COPY_DEST/$archiveFileName" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT


ssh $DEPLOY_USER@$DEPLOY_HOST "$(which bash) -s" << EOF
    cd $DEPLOY_APPROOT
     tar -zxvf $archiveFileName
    rm $archiveFileName

    if [ $BACKUP_DB -eq 1 ]; then
        mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > "$REV_FOLDER/deployment/database/backup/backup.sql"
    fi

    if [ $DEPLOY_DB -eq 1 ]; then
        mysql --host=$DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT  --user=$DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE < "$REV_FOLDER/deployment/database/structure/tables/$REV_FOLDER.sql"
    fi

    cp -af "$REV_FOLDER/deployment/files/$DEPLOYENV/." "$REV_FOLDER/"

    if [ -d "current" ]; then
        cp -af "current/$DEPLOY_DATA_FOLDER/." "$REV_FOLDER/$DEPLOY_DATA_FOLDER/"
        mv "current" "$OLDREV_FOLDER"
    fi

    mv "$REV_FOLDER" "current"
EOF