#!/usr/bin/env bash
set -e
source .config/build

if [ "$RECIPE" == "default" ]
then
  exit 0
fi

cd $BE_SOURCE

if [ "$DRONE" == "true" ]
then
      composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
else
      composer install
fi

exit $?