#!/usr/bin/php
<?php

function decode_create($instance, $type, $image, $date)
{
	$states = array(
		"VM running" => "running",
	);

	if (empty($instance["powerState"]))
		$state = "pending";
	else
		$state = str_replace(array_keys($states), array_values($states), $instance["powerState"]);

	$id = basename($instance["id"]);
	$ip = $instance["publicIpAddress"];
	$fqdn = $instance["fqdns"];
	$zone = $instance["location"];
	$key = "-";

	if (!empty($fqdn)) {
		$host = $fqdn;
		$tmp = explode("-", $fqdn);
		$key = $tmp[0];
	} else if (!empty($ip))
		$host = $ip;
	else
		$host = "-";

	echo "$host $state $key $zone $type $id $image $date -\n";
}


$json = "";
$fp = fopen("php://stdin", "r");

while ($line = fgets($fp))
	$json .= $line;

fclose($fp);
$instance = json_decode($json, true);

if (is_null($instance))
	die("error: $json\n");

$date = date("Y-m-d");
decode_create($instance, $argv[1], $argv[2], $date);
