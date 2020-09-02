#!/bin/bash
docker build -t ft_server .
docker run -p 80:80 -p 443:443 -dit ft_server
