#!/usr/bin/env bash
set -e

source .config/build
source $SCRIPTS_FOLDER/util.sh

if [ "$RECIPE" == "default" ]
then
  exit 0
fi

DEST_DIR=../$DEST/backend

# Build dest
mkdir -p $DEST

printInfo "Install dependencies"
CI_BUILD=$CI_BUILD \
      $SCRIPTS_FOLDER/backend/install.sh

OLD_DIR=$PWD
cd $BE_SOURCE
printInfo "Copy folders and files to dist"
rsync -atRlq --ignore-errors . $DEST_DIR \
      --exclude='/public' \
      --exclude='/_public' \
      --exclude='/craft/storage' \
      --exclude='/storage' \
      --exclude='/*.*' \
      --exclude='.*' \
      --exclude='.*/'

rsync -adq --ignore-errors *.lock $DEST_DIR

rsync -adq --ignore-errors composer.json $DEST_DIR

rsync -adq --ignore-errors *.* $DEST_DIR \
      --exclude='*/' \
      --exclude='.*' \
      --exclude='*.md' \
      --exclude='*.js' \
      --exclude='composer.*' \
      --exclude='phpunit.xml' \
      --exclude='*.json'

cd $OLD_DIR

DEST_DIR=../$DEST/$UI_SOURCE
cd $UI_SOURCE

rsync -atRlq --ignore-errors . $DEST_DIR

cd $OLD_DIR
exit 0
