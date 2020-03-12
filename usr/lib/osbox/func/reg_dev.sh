#!/usr/bin/php
<?php

// load some vars
$ini = parse_ini_file ( "/usr/share/osbox/variables");


$hwfilename = $ini['OSBOX_HARDWARE'];
$idfilename = $ini['OSBOX_ID_FILE'];

// read the hw-file
$handle = fopen($hwfilename, "r");
$contents = fread($handle, filesize($hwfilename));
fclose($handle);

// decode the filecontents
$thedata = json_decode($contents);




// send the data, return a hash.
$data_string = json_encode($thedata);

$ch = curl_init('http://api.surfwijzer.nl/blackbox/');
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Content-Type: application/json',
    'Content-Length: ' . strlen($data_string))
);

$result = curl_exec($ch);


// Check HTTP status code
if (!curl_errno($ch)) {
  switch ($http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE)) {
    case 200:  # OK
      break;
    default:
      echo 'Unexpected HTTP code: ', $http_code, "\n";
  }
}




// write the hash, delete the hw
$registerdata = json_decode($result);
$registerdata['hash'];

