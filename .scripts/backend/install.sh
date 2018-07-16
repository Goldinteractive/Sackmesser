#!/usr/bin/env bash
set -e
source .config/build

cd $BE_SOURCE

if [ "$CI_BULD" == "1" ]
then
      composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
else
      composer install
fi

exit $?