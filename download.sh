#!/bin/bash
cd srcs
curl -LO http://wordpress.org/latest.tar.gz
curl -LO https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
cd ..
rm download.sh
