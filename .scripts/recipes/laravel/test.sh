#!/usr/bin/env bash
set -e
source .config/build

# Clean dir
rm -rf $TEST_DIR

rsync -a $DEST/* $TEST_DIR
rsync -a --include '*/' --exclude '*' "backend/storage" "$TEST_DIR/backend"

cp $BE_SOURCE/.env.citest $TEST_DIR/$BE_SOURCE/.env
cp $BE_SOURCE/phpunit.xml $TEST_DIR/$BE_SOURCE/phpunit.xml

cd $TEST_DIR/$BE_SOURCE
composer install

# Execute tests
$VENDOR_DIR/bin/phpunit

exit $?
