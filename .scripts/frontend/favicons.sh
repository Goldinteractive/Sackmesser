#!/bin/bash
set -e

# Favicon and Apple Touch Icon Generator

CONVERT_CMD=`which convert`
SRC_IMAGE=$1/source.png
BASE=$1
DEST=$2

mkdir -p $2

if [ -z $CONVERT_CMD ] || [ ! -f $CONVERT_CMD ] || [ ! -x $CONVERT_CMD ];
then
    echo 'ImageMagick needs to be installed to run this script'
    exit;
fi

echo $SRC_IMAGE
if [ -z $SRC_IMAGE ];
then
  echo 'You must set correctly the path to the source image.'
  exit;
fi

if [ ! -f $SRC_IMAGE ];
then
    echo 'Source image \"$SRC_IMAGE\" does not exist.'
    exit;
fi

echo 'Generating square base image'
$CONVERT_CMD $SRC_IMAGE -resize 256x256! $DEST/favicon-256.png

echo 'Generating default ico files'
$CONVERT_CMD $DEST/favicon-256.png -colors 256 $DEST/favicon.ico
$CONVERT_CMD $DEST/favicon-256.png -resize 64x64 $DEST/favicon.png
$CONVERT_CMD $DEST/favicon-256.png -resize 16x16 $DEST/favicon-16x16.png
$CONVERT_CMD $DEST/favicon-256.png -resize 32x32 $DEST/favicon-32x32.png
$CONVERT_CMD $DEST/favicon-256.png -resize 96x96 $DEST/favicon-96x96.png
$CONVERT_CMD $DEST/favicon-256.png -resize 192x192 $DEST/favicon-android-chrome-192x192.png
$CONVERT_CMD $DEST/favicon-256.png -resize 194x194 $DEST/favicon-194x194.png

echo 'Generating touch icons'
$CONVERT_CMD $DEST/favicon-256.png -resize 57x57 $DEST/apple-touch-icon-57x57.png
$CONVERT_CMD $DEST/favicon-256.png -resize 60x60 $DEST/apple-touch-icon-60x60.png
$CONVERT_CMD $DEST/favicon-256.png -resize 72x72 $DEST/apple-touch-icon-72x72.png
$CONVERT_CMD $DEST/favicon-256.png -resize 76x76 $DEST/apple-touch-icon-76x76.png
$CONVERT_CMD $DEST/favicon-256.png -resize 114x114 $DEST/apple-touch-icon-114x114.png
$CONVERT_CMD $DEST/favicon-256.png -resize 120x120 $DEST/apple-touch-icon-120x120.png
$CONVERT_CMD $DEST/favicon-256.png -resize 144x144 $DEST/apple-touch-icon-144x144.png
$CONVERT_CMD $DEST/favicon-256.png -resize 152x152 $DEST/apple-touch-icon-152x152.png
$CONVERT_CMD $DEST/favicon-256.png -resize 180x180 $DEST/apple-touch-icon-180x180.png

echo 'Generating the windows icons'
$CONVERT_CMD $DEST/favicon-256.png -resize 144x144 $DEST/windows-tile-144x144.png

echo 'Removing temp files'
rm -rf $DEST/favicon-256.png