#!/usr/bin/env bash

printf "\033[0;32mCheck composer depenencies.\033[0m \n"
composer install

printf "\033[0;32mCheck Yarn depenencies.\033[0m \n"
yarn install

exit 0
