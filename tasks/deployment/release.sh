#!/bin/bash

source "$CONFIG_FOLDER/deployment"

COL_HL="\033[0;32m"
COL_ERR="\033[0;31m"
COL_CLEAR="\033[0m"
REV_FILE="$DEPLOYMENT_FOLDER/rev"


currentRev=$(cat $REV_FILE)

newRev=$(($currentRev+1))

printf "$COL_HL Creating new revision: $newRev $COL_CLEAR\n"


$DEPLOY_SCRIPTS_FOLDER/test.sh
if [ $? -eq 1 ]; then
    printf "$COL_ERR Unit Test failed $COL_CLEAR\n"
    printf "$COL_ERR Release cancelled. Please fix the unit test $COL_CLEAR\n"
    exit 1
fi

if [ $USE_DB -eq 1 ]; then
    REV=$newRev \
    CONFIG_FOLDER=$CONFIG_FOLDER \
    DEPLOYMENT_FOLDER=$DEPLOYMENT_FOLDER \
        DEPLOY_SCRIPTS_FOLDER=$DEPLOY_SCRIPTS_FOLDER \
        $DEPLOY_SCRIPTS_FOLDER/dbdump.sh
fi

if [ $USE_GIT -eq 1 ]; then
    printf "$COL_HL Create Git tag$COL_CLEAR\n"
    git tag -a "rev-$newRev" -m "Revision $newRev created"
    git push origin "rev-$newRev"
fi


#finally write to new file
echo $newRev > $REV_FILE