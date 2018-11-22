<?php

function coord () {
    return rand(0, 9);
}

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
         'x' => coord(),
         'y' => coord()],
        ['name' => 'test2',
         'gear' => [],
         'x' => coord(),
         'y' => coord()],
    ]
);

header('Content-type: application/json');
header('Content-Length: ' . strlen($response));
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Credentials: true');

echo $response;
