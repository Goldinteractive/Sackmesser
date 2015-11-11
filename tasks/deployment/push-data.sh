#!/bin/bash

source "$CONFIG_FOLDER/deployment"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

DB_DATA_PUSH_FILE=`mktemp`

# backup files
printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"

  ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "$(which bash) -s" << EOF
        cd $DEPLOY_APPROOT

        tar -cvzf "current/$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "current/$DEPLOY_DATA_FOLDER/../" "files"
        rm -rf current/$DEPLOY_DATA_FOLDER/*
EOF

# upload files
printf "\033[0;32m Upload files to $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
scp -r "$DEPLOY_DATA_FOLDER/." $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER/

if [ $? -ne 0 ]; then
    exit 1
fi

# db
mysqldump --add-drop-table -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW $DB_DATABASE  > $DB_DATA_PUSH_FILE

scp -r $DB_DATA_PUSH_FILE $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/db_data_push_file.sql

if [ $USE_DB -eq 1 ]; then
    printf "\033[0;32m Backup DB with Data \033[0m \n"
     ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "$(which bash) -s" << EOF
        cd $DEPLOY_APPROOT
        mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > "current/$DEPLOY_DATA_BACKUP_FOLDER/backup_db.sql"

        mysql --host=$DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT  --user=$DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE < "db_data_push_file.sql"
        exit
EOF
fi