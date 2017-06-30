#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

CURRENTREV=$(getCurrentRev)
CURRENTREVFOLDER=$(getCurrentRevFolder)
ROLLBACKTOREV=$((CURRENTREV-1))
ROLLBACKTOREV_FOLDER="rev$ROLLBACKTOREV"

if [ $CURRENTREV -eq 1 ]; then
    printf "$COLOR_RED""We can't rollback below revision 1. Abort. $COLOR_OFF \n"
    exit 1
fi

printf "$COLOR_GREEN""Rollback to Revision $ROLLBACKTOREV. $COLOR_OFF \n"

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
                  $DEPLOY_DB_DATABASE < "current/$DEPLOYMENT_FOLDER/database/backup/backup.sql"
        else
           printf "COLOR_RED""DB was not rolled back because the setting BACKUP_DB is set to false $COLOR_OFF \n"
        fi
    fi

    mv "current" "$CURRENTREVFOLDER"
    mv "$ROLLBACKTOREV_FOLDER" "current"
EOF

if [ $? -ne 0 ]; then
    exit 1
fi