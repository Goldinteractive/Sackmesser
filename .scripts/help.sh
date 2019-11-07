#!/usr/bin/env bash
set -eu

#!/bin/bash
START="\033[35;1m"
START2="\x1B[36m"
END="\033[0m"

printf "
Command list:
Work on the project:
  $START  make up                    $END Start the docker containers for the project
  $START  make stop                  $END Stops the started docker containers of the project
  $START  make connect               $END Connect to the docker container
  $START  make install               $END Install all project dependencies
  $START  make watch                 $END Watch the js and the scss files compiling them
  $START  make build-fe              $END Build the js and the scss files
  $START  make icons                 $END Generate the icons
  $START  make favicons              $END Generate the favicons
  $START  make feature-install-*     $END Install a feature (* = feature-name)
  $START  make feature-remove-*      $END Remove a feature (* = feature-name), but keep local files

Deploy the project:
  $START  [git branches]             $END Push to release/environment to deploy the project

Synchronize files (uploads):
  $START  make push-data-*           $END Push data to environment (* = production, staging …)
  $START  make pull-data-*           $END Pull data from environment (* = production, staging …)
  "
