#!/bin/bash
## bash
# @Author: i-curve
# @Date: 2024-05-15 20:01:26
# @Last Modified by: i-curve
# @Name:
##
domain=test.com
echo "server {
        listen 80;
        listen [::]:80;
        server_name $domain;
        rewrite ^(.*) https://\$server_name\$1 permanent;
}
server {
        listen 443 ssl;
        listen [::]:443 ssl;
        root /var/www/public;
        index index.html index.htm index.nginx-debian.html;
        server_name $domain;
        ssl_certificate /var/www/ssl/$domain/fullchain.pem;
        ssl_certificate_key /var/www/ssl/$domain/private.key;
        location / {
                try_files \$uri \$uri/ =404;
        }
}" >$domain
