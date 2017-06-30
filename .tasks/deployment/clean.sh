#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"
loadEnvConfig $DEPLOYENV

CURRENTREV=$(getCurrentRev)
OLDREV=$(getOldRev)
CURRENTREVFOLDER=$(getCurrentRevFolder)
OLDREVFOLDER=$(getOldRevFolder)

if [ $CURRENTREV -le 1 ]; then
    printf "\033[0;31m  Nothing to clean. \033[0m \n"
    exit 1
fi

ssh $DEPLOY_USER@$DEPLOY_HOST -p $DEPLOY_PORT   "bash -s" << EOF
    cd $DEPLOY_APPROOT

    mv $OLDREVFOLDER "tmprev"
    rm -rf rev*
    mv "tmprev" $OLDREVFOLDER
EOF