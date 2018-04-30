#!/usr/bin/env bash

DB=$DB
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_USER=$DB_USER
DB_PW=$DB_PW

TEMP_TABLES=`mktemp`

# remove tables
mysql $DB -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "SHOW TABLES;" | grep -v '^Tables_in_' > $TEMP_TABLES

for TABLE in `cat $TEMP_TABLES`; do
        echo Delete table $TABLE;
        mysql $DB -h $DB_HOST --port=$DB_PORT -u $DB_USER --password=$DB_PW -e "SET FOREIGN_KEY_CHECKS=0;DROP TABLE $TABLE;"
done

exit 0
