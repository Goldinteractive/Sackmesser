#!/bin/bash

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

if [ $CURRENTREV -eq 0 ]; then
    printf "\033[0;31m We can't rollback below revision 0. Cancel. \033[0m \n"
    exit 1
fi

printf "\033[0;32m Rollback to Revision $ROLLBACKTOREV. \033[0m \n"

printf "\033[0;32m We need the password so we can execute the necessary steps to activate our changes \033[0m \n"
printf "Password: \033[0;32m $DEPLOY_PW \033[0m \n"

ssh $DEPLOY_USER@$DEPLOY_HOST "$(which bash) -s" << EOF
    cd $DEPLOY_APPROOT

    if [ $DEPLOY_DB -eq 1 ]; then
        if [ $BACKUP_DB -eq 1 ]; then
            mysql --silent \
                  --skip-column-names \
                  -e "SHOW TABLES" DB_NAME | xargs -L1 -I% echo 'DROP TABLE `%`;' | mysql -v DB_NAME

            mysql --host=$DEPLOY_DB_HOST \
                  --port=$DEPLOY_DB_PORT \
                  --user=$DEPLOY_DB_USER \
                  --password=$DEPLOY_DB_PW \
                  $DEPLOY_DB_DATABASE < "$REV_FOLDER/deployment/database/structure/tables/backup.sql"
        else
           printf "\033[0;32m DB was not rolled back because the setting BACKUP_DB is set to false \033[0m \n"
        fi
    fi

    mv "current" "$REV_FOLDER"
    mv "$ROLLBACKTOREV_FOLDER" "current"
EOF