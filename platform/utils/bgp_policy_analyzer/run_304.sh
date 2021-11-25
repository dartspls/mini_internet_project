#!/bin/bash
STD_USER="$SUDO_USER"
WEBROOT=/var/www/html/

if [[ "$#" -ge 1 ]]; then
    STD_USER="$1"
fi
if [[ "$#" -ge 2 ]]; then
    WEBROOT="$2"
fi

rm as.db || true
sudo -u ${STD_USER} python3 cfparse.py ../../config/
while true
do
    sudo -u "${STD_USER}" python3 lgparse.py ../../groups/
    sudo -u "${STD_USER}" python3 lganalyze.py print-html | sudo -u "${STD_USER}" tee analysis.html > /dev/null

    mkdir -p "${WEBROOT}/bgp_analyzer/"
    cp ./analysis.html "${WEBROOT}/bgp_analyzer/"

    echo 'html file sent'
    sleep 120
done
