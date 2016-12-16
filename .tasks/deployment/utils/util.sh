#!/bin/bash

ask() {
    DEFAULT=1
    DEFAULT_TEMPLATE="(Y/N=Default)"

    case $2 in
        [0] ) DEFAULT=0; DEFAULT_TEMPLATE="(Y=Default/N)";;
        * ) DEFAULT=1;;
    esac

    printf "\033[0;32m$1 \033[0m \n"
    read -p "Answer: $DEFAULT_TEMPLATE: " yn

    case $yn in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) return $DEFAULT;;
    esac
}