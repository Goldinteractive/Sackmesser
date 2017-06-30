#!/usr/bin/env bash

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_OFF="\033[0m"

source "$CONFIG_FOLDER/deployment"

ask() {
    local DEFAULT=1
    local DEFAULT_TEMPLATE="(Y/N=Default)"

    case $2 in
        [0] ) DEFAULT=0; DEFAULT_TEMPLATE="(Y=Default/N)";;
        * ) DEFAULT=1;;
    esac

    printf "$COLOR_GREEN$1 $COLOR_OFF \n"
    read -p "Answer: $DEFAULT_TEMPLATE: " yn

    case $yn in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) return $DEFAULT;;
    esac
}

loadEnvConfig() {
    local DEPLOYENV=$1
    local DEPLOYMENT_CONFIG_FILE="$CONFIG_FOLDER/deployment.$DEPLOYENV"

    if [ ! -e $DEPLOYMENT_CONFIG_FILE ]; then
        printf "$COLOR_RED Unknown Environment: $DEPLOYENV $COLOR_OFF \n"
        exit 1
    fi

    source $DEPLOYMENT_CONFIG_FILE
}

getCurrentRev() {
    local REV_FILE=$DEPLOYMENT_FOLDER/rev

    echo $(cat $REV_FILE)
}

getCurrentRevFolder() {
    local CURRENTREV=$(getCurrentRev)
    echo "rev$CURRENTREV"
}

getOldRev() {
    local CURRENTREV=$(getCurrentRev)
    echo $(($CURRENTREV-1))
}

getOldRevFolder() {
    local OLDREV=$(getOldRev)
    echo "rev$OLDREV"
}

removeDevFilesFromDist() {
    printf "$COLOR_GREEN""Remove dev files from dist folder $COLOR_OFF \n"
    for item in "${DEPLOY_DATA_FOLDERS[@]}"
    do
      rm -rf ./$COPY_DEST/$item/*
    done
}

backupDataFiles() {
    for item in "${DEPLOY_DATA_FOLDERS[@]}"
    do
        printf "$COLOR_GREEN""Backup files in $item $COLOR_OFF \n"

        FILENAME="backup_${item//\//_}.tar.gz"
        FOLDERNAME=$(basename $item)

        echo $item

        if [ -d $item ]; then
            tar -cvzf "$DEPLOY_DATA_BACKUP_FOLDER/$FILENAME" -C "$item/../" $FOLDERNAME
        fi
    done
}

copyEnvFilesToDist() {
    printf "$COLOR_GREEN""Copy env files to dist folder $COLOR_OFF \n"
    cp -af $DEPLOYMENT_FOLDER/files/$DEPLOYENV/. "$COPY_DEST/"
}

copyDeploymentFolderToDist() {
    printf "$COLOR_GREEN""Copy deployment folder to dist folder $COLOR_OFF \n"
    rsync -avtR --ignore-errors $DEPLOYMENT_FOLDER "$COPY_DEST/" \
        --exclude='data/*'
}