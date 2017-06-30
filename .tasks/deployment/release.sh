#!/usr/bin/env bash

source "$DEPLOY_SCRIPTS_FOLDER/utils/util.sh"

REV_FILE="$DEPLOYMENT_FOLDER/rev"
CURRENTREV=$(getCurrentRev)
NEWREV=$(($CURRENTREV+1))

printf "$COLOR_GREEN""Creating new revision: $NEWREV $COLOR_OFF\n"


$DEPLOY_SCRIPTS_FOLDER/test.sh
if [ $? -eq 1 ]; then
    printf "$COLOR_RED""Unit Test failed $COLOR_OFF\n"
    printf "$COLOR_RED""Release cancelled. Please fix the unit test $COLOR_OFF\n"
    exit 1
fi

if [ $USE_GIT -eq 1 ]; then
    printf "$COLOR_GREEN Create Git tag$COLOR_OFF\n"
    git tag -a "rev-$NEWREV" -m "Revision $NEWREV created"
    git push origin "rev-$NEWREV"

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

#finally write to new file
echo $NEWREV > $REV_FILE