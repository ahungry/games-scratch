<?php

// Run me with: php -S 127.0.0.1:12345
$response = json_encode(
    [
        ['name' => 'test', 'x' => 8, 'y' => 3],
        ['name' => 'test2', 'x' => 3, 'y' => 2],
    ]
);

header('Content-type: application/json');
header('Content-Length: ' . strlen($response));
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');

echo $response;
