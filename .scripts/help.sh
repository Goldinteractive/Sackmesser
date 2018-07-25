#!/usr/bin/env bash
set -eu

#!/bin/bash
START="\033[35;1m"
START2="\x1B[36m"
END="\033[0m"

printf "
Command list:
Work on the project:
  $START  make docker-up        $END start the docker engine (this is required for all tasks)
  $START  make docker-connect   $END connect to the docker container
  $START  make install          $END install all project dependencies
  $START  make watch            $END watch the js and the scss files compiling them
  $START  make icons            $END generate the icons
  $START  make favicons         $END generate the favicons

Deploy the project:
  $START  [git branches]        $END push to release/environment to deploy the project

Synchronize files (uploads):
  $START  make push-data-*      $END push data to environment (* = production, staging …)
  $START  make pull-data-*      $END pull data from environment (* = production, staging …)
  "
