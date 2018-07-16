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