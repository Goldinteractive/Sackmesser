#!/bin/bash

source "$CONFIG_FOLDER/deployment"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

DB_DATA_PUSH_FILE=`mktemp -t deployment`

DB_DATA_BACKUP_FILE="current/$DEPLOY_DATA_BACKUP_FOLDER/backup_db.sql"

# db
mysqldump --add-drop-table -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $DB_DEV_DATABASE  > $DB_DATA_PUSH_FILE

scp -r $DB_DATA_PUSH_FILE $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT/db_data_push_file.sql

if [ $USE_DB -eq 1 ]; then
    printf "\033[0;32m Backup DB with Data \033[0m \n"
     ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        cd $DEPLOY_APPROOT

        if [ -e $DB_DATA_BACKUP_FILE ]; then
            mv $DB_DATA_BACKUP_FILE "current/$DEPLOY_DATA_BACKUP_FOLDER/$(date +%s)_backup_db.sql"
        fi

        mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > $DB_DATA_BACKUP_FILE

        if [ \$? -ne 0 ]; then
            printf "\033[0;31m Backup file was not created! \033[0m \n"
            exit 1
        fi

        mysql --host=$DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT  --user=$DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE < "db_data_push_file.sql"

        rm db_data_push_file.sql
        exit
EOF
fi
