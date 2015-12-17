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

# backup files
printf "\033[0;32m Backup files in $DEPLOY_DATA_FOLDER \033[0m \n"
tar -cvzf "$DEPLOY_DATA_BACKUP_FOLDER/backup_files.tar.gz" -C "$DEPLOY_DATA_FOLDER/../" "files"
rm -rf $DEPLOY_DATA_FOLDER/*

# get files
printf "\033[0;32m Download files from $DEPLOY_APPROOT/current/$DEPLOY_DATA_FOLDER \033[0m \n"
rsync -azP -e "ssh -p $DEPLOY_PORT" $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_APPROOT"/current/$DEPLOY_DATA_FOLDER/." $DEPLOY_DATA_FOLDER/

if [ $? -ne 0 ]; then
    exit 1
fi

# backup db
if [ $USE_DB -eq 1 ]; then
    printf "\033[0;32m Backup DB with Data \033[0m \n"
    $MYSQLDUMP -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $DB_DEV_DATABASE  > "$DEPLOY_DATA_BACKUP_FOLDER/backup_db.sql"

    if [ $? -ne 0 ]; then
        exit 1
    fi

    # get db
    printf "\033[0;32m Download DB \033[0m \n"
    ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "$(which bash) -s" << EOF
        mysqldump -h $DEPLOY_DB_HOST --port=$DEPLOY_DB_PORT -u $DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE  > $DB_DATA_PULL_FILE
EOF

    if [ $? -ne 0 ]; then
        exit 1
    fi

    scp $DEPLOY_USER@$DEPLOY_HOST:$DB_DATA_PULL_FILE $DB_DATA_PULL_FILE

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



