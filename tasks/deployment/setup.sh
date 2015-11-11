#!/bin/bash

#load config
DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"
if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
    printf "\033[0;31m Unknown Environment: $DEPLOYENV \033[0m \n"
    exit 1
fi

source $DEPLOYMENT_CONFIG_FILE

printf "Enter the SSH password for user ($DEPLOY_USER)\n"

ssh-copy-id $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT


if ! command -v mysql > /dev/null; then
    echo -n "MySQL not found. Give the Path to MySQL (default: /Applications/MAMP/Library/bin/mysql) press [ENTER]: "
    read MYSQL

    rm -f /usr/local/bin/mysql
    sudo ln -s $MYSQL /usr/local/bin/mysql
fi


if  ! command -v mysqldump  > /dev/null; then
    echo -n "MySQLDump not found. Give the Path to MySQLDump (default: /Applications/MAMP/Library/bin/mysqldump) press [ENTER]: "
    read MYSQLDUMP

    rm -f /usr/local/bin/mysqldump
    sudo ln -s $MYSQLDUMP /usr/local/bin/mysqldump
fi

