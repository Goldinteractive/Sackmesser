<?php include_once('templates/include/functions.php'); ?>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
        <head>
                <meta charset="utf-8">
                <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
                <title></title>
                <meta name="description" content="">
                <base href='<?=$BASE_PATH?>' />
                <meta name="viewport" content="width=device-width">
                <link rel="shortcut icon"  href="favicon.ico">
                <link type="text/plain" rel="author" href="humans.txt" />
                <link rel="stylesheet" href="assets/css/style.css">
                <script>
                    var CONSTANTS = {
                        BASE_PATH: '<?php echo($BASE_PATH) ?>',
                        APP_ROOT: '<?php echo($APP_ROOT) ?>'
                    }
                </script>
   
                <!-- CSS crossbrowser iconset loading -->
                <script>
                /* grunticon Stylesheet Loader | https://github.com/filamentgroup/grunticon | (c) 2012 Scott Jehl, Filament Group, Inc. | MIT license. */
                window.grunticon=function(e){if(e&&3===e.length){var t=window,n=!(!t.document.createElementNS||!t.document.createElementNS("http://www.w3.org/2000/svg","svg").createSVGRect||!document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Image","1.1")||window.opera&&-1===navigator.userAgent.indexOf("Chrome")),o=function(o){var r=t.document.createElement("link"),a=t.document.getElementsByTagName("script")[0];r.rel="stylesheet",r.href=e[o&&n?0:o?1:2],a.parentNode.insertBefore(r,a)},r=new t.Image;r.onerror=function(){o(!1)},r.onload=function(){o(1===r.width&&1===r.height)},r.src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw=="}};
                grunticon( [ "assets/css/iconsbuild/icons.data.svg.css", "assets/css/iconsbuild/icons.data.png.css", "assets/css/iconsbuild/icons.fallback.css" ] );
                </script>
                <noscript><link href="assets/css/iconsbuild/icons.fallback.css" rel="stylesheet"></noscript>
                <script src="//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"></script>
        </head>
        <body class="loading">