#!/bin/bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
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

ask "Deploy to $DEPLOY_HOST ($DEPLOY_APPROOT)?"

if [ $? -ne 0 ]; then
    exit 1
fi

#htaccess stuff
ENV_HTACCESS="$WEBROOT_PATH/.htaccess.$DEPLOYENV"
DEFAULT_HTACCESS="$WEBROOT_PATH/.htaccess"

if [ -e $ENV_HTACCESS ]; then
    cp $ENV_HTACCESS "$COPY_DEST/$WEBROOT_PATH/.htaccess"
else
    cp $DEFAULT_HTACCESS "$COPY_DEST/$WEBROOT_PATH/.htaccess"
fi

# env stuff
cp ".env.$DEPLOYENV" $COPY_DEST/.env

# remove dev files
rm -rf ./$COPY_DEST/$DEPLOY_DATA_FOLDER/*

# copy env files
cp -af $DEPLOYMENT_FOLDER/files/$DEPLOYENV/. "$COPY_DEST/"

#copy deployment folder
rsync -avtR --ignore-errors $DEPLOYMENT_FOLDER "$COPY_DEST/" \
    --exclude='data/*'

mv "$COPY_DEST" "$REV_FOLDER"

archiveFileName="rev$CURRENTREV.tar.gz"
tar --exclude="$archiveFileName" -cvzf "$REV_FOLDER/$archiveFileName" -C "$REV_FOLDER/../" $REV_FOLDER

mv "$REV_FOLDER" "$COPY_DEST"

printf "Now we want to upload our archive to the server.\n"

scp -P $DEPLOY_PORT "$COPY_DEST/$archiveFileName" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT

if [ $? -eq 1 ]; then
    exit 1
fi

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
    cd $DEPLOY_APPROOT

    if [ -d "$REV_FOLDER" ]; then
        rm -rf "$REV_FOLDER"
    fi

    tar -zxvf $archiveFileName
    rm $archiveFileName

    if [ $CURRENTREV -gt 1 ]; then
        if [ $BACKUP_DB -eq 1 ]; then
            mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > "$REV_FOLDER/.deployment/database/backup/backup.sql"
        fi

        if [ $DEPLOY_DB -eq 1 ]; then
            mysql --host=$DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT  --user=$DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE < "$REV_FOLDER/.deployment/database/structure/tables/$REV_FOLDER.sql"
        fi
    fi

    if [ -d "current" ]; then
        cp -af "current/$DEPLOY_DATA_FOLDER/." "$REV_FOLDER/$DEPLOY_DATA_FOLDER/"

        if [ -d $OLDREV_FOLDER ]; then
            rm -rf $OLDREV_FOLDER
        fi

        mv "current" "$OLDREV_FOLDER"
    fi

    mv "$REV_FOLDER" "current"
EOF

if [ $? -ne 0 ]; then
    exit 1
fi
