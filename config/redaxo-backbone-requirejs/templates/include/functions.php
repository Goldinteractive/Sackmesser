<?php

// Setup the project environment
$ENV = preg_match("/localhost|10.0.1/",$_SERVER["HTTP_HOST"]) ? 'dev' : 'prod';
$BASE_PATH = ($ENV === 'dev' ?  "http://" . $_SERVER["HTTP_HOST"]. str_replace("index.php","",$_SERVER["SCRIPT_NAME"]) : "http://" . $_SERVER["HTTP_HOST"] . "/");
$APP_ROOT = $ENV === 'dev' ? str_replace("index.php","",$_SERVER["SCRIPT_NAME"]) :"/";