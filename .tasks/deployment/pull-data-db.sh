#!/bin/bash

source "$CONFIG_FOLDER/deployment"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

DB_DATA_PULL_FILE="db_data_pull_file.sql"
DB_DATA_BACKUP_FILE="$DEPLOY_DATA_BACKUP_FOLDER/backup_db.sql"

# backup db
if [ $USE_DB -eq 1 ]; then
    printf "\033[0;32m Backup DB with Data \033[0m \n"

    $MYSQLDUMP -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $DB_DEV_DATABASE  > $DB_DATA_BACKUP_FILE

    if [ $? -ne 0 ]; then
        exit 1
    fi

    cp $DB_DATA_BACKUP_FILE "$DEPLOY_DATA_BACKUP_FOLDER/$(date +"%Y%m%d_%H%M%S")_backup_db.sql"

    # get db
    printf "\033[0;32m Download DB \033[0m \n"
    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
        mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > $DB_DATA_PULL_FILE
EOF

    if [ $? -ne 0 ]; then
        exit 1
    fi

    scp -P $DEPLOY_PORT $DEPLOY_USER@$DEPLOY_HOST:$DB_DATA_PULL_FILE $DB_DATA_PULL_FILE

    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "rm -f $DB_DATA_PULL_FILE"

    # clear db
    DB=$DB_DEV_DATABASE \
    DB_HOST=$DB_DEV_HOST \
    DB_PORT=$DB_DEV_PORT \
    DB_USER=$DB_DEV_USER \
    DB_PW=$DB_DEV_PW \
        $DEPLOY_SCRIPTS_FOLDER/utils/db-clear-tables.sh

     mysql $DB_DEV_DATABASE -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW < $DB_DATA_PULL_FILE

     rm -f $DB_DATA_PULL_FILE


    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

