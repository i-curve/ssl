#!/bin/bash

if [[ -z "$1" ]]; then
    echo "需要输入域名" && exit 0
fi

domain=$1
if ! which ~/.acme.sh/acme.sh; then
    curl https://get.acme.sh | sh -s email=my@example.com
fi

if ! which socat; then
    apt install -y socat
fi

if which nginx; then
    service nginx stop
fi

# 申请证书
~/.acme.sh/acme.sh --issue -d "$domain" --standalone

# 安装证书
mkdir -p /var/www/ssl/$domain

~/.acme.sh/acme.sh --install-cert -d $domain \
    --key-file /var/www/ssl/$domain/private.key \
    --fullchain-file /var/www/ssl/$domain/fullchain.pem

if which nginx; then
    service nginx start
fi
