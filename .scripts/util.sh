#!/usr/bin/env bash
set -eu

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_OFF="\033[0m"

printInfo() {
    printf "$COLOR_GREEN$1 $COLOR_OFF \n"
}

printError() {
    printf "$COLOR_RED$1 $COLOR_OFF \n"
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

ask() {
    local DEFAULT=1
    local DEFAULT_TEMPLATE="(Y/N=Default)"

    case ${2:-} in
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

executeSSH() {
    local SCRIPT=$1

   /bin/drone-ssh --host "$DEPLOY_HOST" \
    --port "$DEPLOY_PORT" \
    --username "$DEPLOY_USER" \
    --script "$SCRIPT"
}

callRecipeEvent() {
    local RECIPE=$1
    local FILE=$RECIPES_FOLDER/$RECIPE/$2.sh

    if [ -f "$FILE" ]; then
        $FILE
        return $?
    fi

    return 0
}