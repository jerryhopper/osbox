#!/usr/bin/php
<?php

$url = "https://blackbox.surfwijzer.nl";
$orignal_parse = parse_url($url, PHP_URL_HOST);
$get = stream_context_create(array("ssl" => array("capture_peer_cert" => TRUE)));
$read = stream_socket_client("ssl://".$orignal_parse.":443", $errno, $errstr,30, STREAM_CLIENT_CONNECT, $get);
$cert = stream_context_get_params($read);
$certinfo = openssl_x509_parse($cert['options']['ssl']['peer_certificate']);



if(!file_exists("/etc/osbox/ssl/blackbox.surfwijzer.nl")){
    mkdir("/etc/osbox/ssl/blackbox.surfwijzer.nl",0777, true);
}

if( file_exists("/etc/osbox/ssl/blackbox.surfwijzer.nl/ssl.ca")  &&  ( time()-$certinfo['validTo_time_t'] ) < (3600*48)  ){
    die();
}


echo ">";
echo "Certificate download"


#echo '<pre>';
print_r($certinfo);
#echo '</pre>';

$valid_from = date(DATE_RFC2822,$certinfo['validFrom_time_t']);
$valid_to = date(DATE_RFC2822,$certinfo['validTo_time_t']);
echo "Valid From: ".$valid_from.", Valid To:".$valid_to."";


$url = "https://blackbox.surfwijzer.nl/x.php";

if ($stream = fopen($url, 'r')) {
    // print all the page starting at the offset 10
    $data= json_decode(stream_get_contents($stream,-1),true);
    fclose($stream);
}


function writedata($filename,$data){
    if (!$handle = fopen($filename, 'w+')) {
         echo "Cannot open file ($filename)";
         exit;
    }
    if (fwrite($handle, $data) === FALSE) {
        echo "Cannot write to file ($filename)";
        exit;
    }
}

foreach( $data as $key=>$value ){
        writedata("/etc/osbox/".$key,$value);
}

