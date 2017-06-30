#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

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