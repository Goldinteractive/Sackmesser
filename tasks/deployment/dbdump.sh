#!/bin/bash

#load config
source "$CONFIG_FOLDER/deployment"

DUMP_FILE="$DUMP_FOLDER/rev$REV.sql"
TABLES_FILE="$DUMP_FOLDER/tables.txt"
TABLES_TMP_FILE="$DUMP_FOLDER/tables_tmp.txt"

if [ $REV -eq 1 ]; then
    $MYSQLDUMP -d -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW $DB_DATABASE  > $DUMP_FILE
else
    #create temp db
    TEMPDB=$DB_DATABASE"_deploy"

    $MYSQL -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "CREATE DATABASE $TEMPDB"

    for SQL in $DUMP_FOLDER/*.sql; do
        echo importing $SQL;
        $MYSQL $TEMPDB -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW < $SQL
    done


    DUMP_TABLE=$DUMP_FOLDER/dbdump_table1.sql
    DUMP_TABLE_TMP=$DUMP_FOLDER/dbdump_table2.sql

    $MYSQLDUMP -d -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW $DB_DATABASE  > $DUMP_TABLE
    $MYSQLDUMP -d -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW $TEMPDB  > $DUMP_TABLE_TMP

    python $DEPLOY_SCRIPTS_FOLDER/compdb.py --foreign-key $DUMP_TABLE_TMP $DUMP_TABLE > $DUMP_FILE

    rm $DUMP_TABLE
    rm $DUMP_TABLE_TMP
#
#    echo "show tables;" | $MYSQL $DB_DATABASE -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW | grep -v '^Tables_in_' > $TABLES_FILE
#    echo "show tables;" | $MYSQL $TEMPDB -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW | grep -v '^Tables_in_' > $TABLES_TMP_FILE
#
#
#    #create tables
#    for x in `cat $TABLES_FILE`; do
#        TABLE_FOUND=0
#
#        for y in `cat $TABLES_TMP_FILE`; do
#            if [ $x = $y ]; then
#                TABLE_FOUND=1
#            fi
#        done
#
#        if [ $TABLE_FOUND -eq 0 ]; then
#            CREATETABLE=`$MYSQL $DB_DATABASE -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "show create table $x;" | grep 'CREATE TABLE'`
#            CREATETABLE="${CREATETABLE#${x}};"
#            CREATETABLE=${CREATETABLE//\\n/}
#            $MYSQL $TEMPDB -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "$CREATETABLE"
#
#            echo "$CREATETABLE" >> $DUMP_FILE
#        fi
#    done
#
#    #alter tables
#    for x in `cat $TABLES_FILE`; do
#         DIFFOUTPUT=`$MYSQLDIFF  --server1=$DB_USER:$DB_PW@$DB_HOST:$DB_PORT \
#                --changes-for=server2 \
#                --force \
#                --quiet \
#                --difftype=sql \
#                "$DB_DATABASE.$x":"$TEMPDB.$x"`
#
#         #DIFFOUTPUT=${DIFFOUTPUT//\`$TEMPDB\`./}
#         #DIFFOUTPUT=${DIFFOUTPUT//\`$DB_DATABASE\`./}
#
#         echo "$DIFFOUTPUT" >> $DUMP_FILE
#
#    done
#
#    #cleanup
#    rm $TABLES_FILE
#    rm $TABLES_TMP_FILE

    $MYSQL -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "DROP DATABASE $TEMPDB"

fi
