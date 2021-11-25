#!/bin/bash
# Upload the matrix every 10 seconds to the locally running webserver
# By default "/var/www/html/" or to the path given by the first argument

WEBROOT=/var/www/html/
if [[ "$#" -ge 1 ]]; then
    WEBROOT="$1"
fi

while true
do
    docker cp MATRIX:/home/matrix.html "$WEBROOT/matrix/matrix.html"
    echo 'matrix sent'
    sleep 10
done
