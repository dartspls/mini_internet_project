#!/bin/bash
WEBROOT=/var/www/html/

while true
do
    docker cp MATRIX:/home/matrix.html $WEBROOT/matrix/matrix.html
    echo 'matrix sent'
    sleep 10
done
