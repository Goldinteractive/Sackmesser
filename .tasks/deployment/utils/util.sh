#!/bin/bash

ask() {
    printf "\033[0;32m$1 \033[0m \n"
    read -p "Answer (Y/N=Default): " yn

    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) return 1; break;;
        * ) return 1; break;;
    esac
}