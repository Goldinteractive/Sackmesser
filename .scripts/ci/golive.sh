#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

APPROOT=$DEPLOY_APPROOT

# setup environment
executeSSH "if [ ! -d $APPROOT/_data ]; then mkdir $APPROOT/_data; fi
    if [ ! -d $APPROOT/_data/uploads ]; then mkdir $APPROOT/_data/uploads; fi
    if [ ! -d $APPROOT/_data/storage ]; then mkdir $APPROOT/_data/storage; fi"

# pre go live
# link data uploads
executeSSH "ln -s ../../_data/uploads $APPROOT/deploy/public/uploads"

callRecipeEvent $RECIPE "golive.pre"

# go live
executeSSH "if [ -d $APPROOT/old ]; then rm -rf $APPROOT/old; fi
    mv $APPROOT/current $APPROOT/old
    mv $APPROOT/deploy $APPROOT/current"

# post go live
callRecipeEvent $RECIPE "golive.post"

exit 0