#!/bin/bash

source "$CONFIG_FOLDER/deployment"

REV_FILE=$DEPLOYMENT_FOLDER/rev
CURRENTREV=$(cat $REV_FILE)
ROLLBACKTOREV=$((CURRENTREV-1))

REV_FOLDER="rev$CURRENTREV"
ROLLBACKTOREV_FOLDER="rev$ROLLBACKTOREV"

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

if [ $CURRENTREV -eq 1 ]; then
    printf "\033[0;31m We can't rollback below revision 1. Cancel. \033[0m \n"
    exit 1
fi

printf "\033[0;32m Rollback to Revision $ROLLBACKTOREV. \033[0m \n"

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT "bash -s" << EOF
    cd $DEPLOY_APPROOT

    if [ $DEPLOY_DB -eq 1 ]; then
        if [ $BACKUP_DB -eq 1 ]; then
            mysql --host=$DEPLOY_DB_HOST \
                  --port=$DEPLOY_DB_PORT \
                  --user=$DEPLOY_DB_USER \
                  --password=$DEPLOY_DB_PW \
                  --silent \
                  --skip-column-names \
                  -e "SHOW TABLES" $DEPLOY_DB_DATABASE | xargs -L1 -I% echo 'SET FOREIGN_KEY_CHECKS = 0; DROP TABLE %;' | mysql --host=$DEPLOY_DB_HOST  --port=$DEPLOY_DB_PORT --user=$DEPLOY_DB_USER --password=$DEPLOY_DB_PW $DEPLOY_DB_DATABASE

            mysql --host=$DEPLOY_DB_HOST \
                  --port=$DEPLOY_DB_PORT \
                  --user=$DEPLOY_DB_USER \
                  --password=$DEPLOY_DB_PW \
                  $DEPLOY_DB_DATABASE < "current/deployment/database/backup/backup.sql"
        else
           printf "\033[0;32m DB was not rolled back because the setting BACKUP_DB is set to false \033[0m \n"
        fi
    fi

    mv "current" "$REV_FOLDER"
    mv "$ROLLBACKTOREV_FOLDER" "current"
EOF


if [ $? -ne 0 ]; then
    exit 1
fi