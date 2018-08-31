#!/usr/bin/env sh
set -e
source .config/build
source $SCRIPTS_FOLDER/util.sh
loadEnvConfig $ENV

APPROOT=$DEPLOY_APPROOT

executeSSH() {
    local SCRIPT=$1
   
   /bin/drone-ssh --host "$DEPLOY_HOST" \
    --port "$DEPLOY_PORT" \
    --username "$DEPLOY_USER" \
    --script "$SCRIPT"
}

# setup environment
executeSSH "if [ ! -d $APPROOT/_data ]; then mkdir $APPROOT/_data; fi
    if [ ! -d $APPROOT/_data/uploads ]; then mkdir $APPROOT/_data/uploads; fi
    if [ ! -d $APPROOT/_data/storage ]; then mkdir $APPROOT/_data/storage; fi"

# symlinks
if [ "$RECIPE" == "craft" ]
then
    executeSSH "ln -s ../../../_data/storage $APPROOT/deploy/backend/craft/storage
        ln -s ../../_data/uploads $APPROOT/deploy/public/uploads"

    # Replace the placeholder with the db pw for the environment
    executeSSH "sed -i "s/@DB_PASSWORD/$DB_PASSWORD/g" $APPROOT/deploy/backend/craft/config/db.php" > /dev/null
    executeSSH "APPENV=$ENV $APPROOT/deploy/backend/crafter/cli.php crafter clearTemplateCache"
fi

# go live
executeSSH "if [ -d $APPROOT/old ]; then rm -rf $APPROOT/old; fi
    mv $APPROOT/current $APPROOT/old
    mv $APPROOT/deploy $APPROOT/current"

exit 0