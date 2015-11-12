#!/bin/bash

#load config
source "$CONFIG_FOLDER/deployment"

DUMP_FILE="$DUMP_FOLDER/rev$REV.sql"
TABLES_FILE="$DUMP_FOLDER/tables.txt"
TABLES_TMP_FILE="$DUMP_FOLDER/tables_tmp.txt"

if [ $REV -eq 1 ]; then
    $MYSQLDUMP -d -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $DB_DEV_DATABASE  > $DUMP_FILE
else
    #create temp db
    TEMPDB=$DB_DEV_DATABASE"_deploy"

    $MYSQL -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW -e "CREATE DATABASE $TEMPDB"

    for SQL in $DUMP_FOLDER/*.sql; do
        echo importing $SQL;
        $MYSQL $TEMPDB -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW < $SQL
    done


    DUMP_TABLE=$DUMP_FOLDER/dbdump_table1.sql
    DUMP_TABLE_TMP=$DUMP_FOLDER/dbdump_table2.sql

    $MYSQLDUMP -d -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $DB_DEV_DATABASE  > $DUMP_TABLE
    $MYSQLDUMP -d -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW $TEMPDB  > $DUMP_TABLE_TMP

    python $DEPLOY_SCRIPTS_FOLDER/compdb.py --foreign-key $DUMP_TABLE_TMP $DUMP_TABLE > $DUMP_FILE

    rm $DUMP_TABLE
    rm $DUMP_TABLE_TMP

    $MYSQL -h $DB_DEV_HOST --port=$DB_DEV_PORT -u $DB_DEV_USER --password=$DB_DEV_PW -e "DROP DATABASE $TEMPDB"

fi
