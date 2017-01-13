<?php

// parse cli arguments into GET variables
parse_str(implode('&', array_slice($argv, 1)), $_GET);

$root = dirname(__FILE__) .'/../..';

$iconsFolder    = $root .'/'. $_GET['iconsFolder'];
$dataFileOutput = $root .'/'. $_GET['dataFileOutput'];
$svgCombOutput  = $root .'/'. $_GET['svgCombOutput'];

$iconsDir = new DirectoryIterator($iconsFolder);

$icons = [];
$iconsMetaData = ['icons' => []];

// build up icon data
foreach ($iconsDir as $info) {
    if (!$info->isDot() && $info->getExtension() == 'svg') {
        $name = $info->getBasename('.svg');
        $innerContent = '';
        $attributes = [];

        $content = file_get_contents($info->getPathname());
        $svg = new SimpleXMLElement($content);

        $svg->registerXPathNamespace('svg', 'http://www.w3.org/2000/svg');
        $svg->registerXPathNamespace('xlink', 'http://www.w3.org/1999/xlink');

        foreach ($svg->children() as $child) {
            $innerContent .= $child->asXML();
        }

        foreach ($svg->attributes() as $attribute => $value) {
            $attributes[$attribute] = (string)$value;
        }

        $icons[$name] = $innerContent;
        $iconsMetaData['icons'][$name] = [
            'attributes' => $attributes
        ];
    }
}

$strIconsMetaData = json_encode($iconsMetaData, JSON_PRETTY_PRINT);

ob_start();
include 'template.php';
$strIcons = ob_get_clean();

// write files
file_put_contents($dataFileOutput, $strIconsMetaData);
file_put_contents($svgCombOutput, $strIcons);


echo 'Icons successfully converted!';
echo PHP_EOL . PHP_EOL;
