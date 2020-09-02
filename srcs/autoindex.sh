#!/bin/bash

VAR=$1
FILE=/etc/nginx/sites-available/nginx.conf

if [ $VAR == "on" ]
then
    sed -i 's/autoindex off/autoindex on/g' $FILE
    nginx -s reload
    echo "Autoindex is ON"
elif [ $VAR == "off" ]
then
    sed -i 's/autoindex on/autoindex off/g' $FILE
    nginx -s reload
    echo "Autoindex if OFF"
else
    echo "Invalid argument"
fi
