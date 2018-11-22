<?php

// Run me with: php -S 127.0.0.1:12345
$response = json_encode(
    [
        ['name' => 'test',
         'gear' => [
             [
                 'back' => [
                     'png' => '32b-red-scarf',
                     'color' => ['r' => 0.2, 'g' => 1, 'b' => 1],
                 ],
                 'default' => [
                     'png' => '32-red-scarf-front',
                     'color' => ['r' =>  3, 'g' => 1, 'b' => 1],
                 ],
             ],
         ],
         'x' => 8,
         'y' => 3],
        ['name' => 'test2',
         'gear' => [],
         'x' => 3,
         'y' => 2],
    ]
);

header('Content-type: application/json');
header('Content-Length: ' . strlen($response));
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');

echo $response;
