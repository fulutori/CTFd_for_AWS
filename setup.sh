#!/bin/bash

sudo apt update
sudo apt -y upgrade

# CTFdのインストール
git clone https://github.com/CTFd/CTFd.git
bash /home/ctf/CTFd/prepare.sh
\cp -f /home/ctf/CTFd_for_AWS/serve.py /home/ctf/CTFd/serve.py

# 最初にIPv4を取得しておく
python3 /home/ctf/CTFd_for_AWS/get_ipv4.py

# nginxのインストール
sudo apt install -y nginx

# サーバー名を設定 ※環境に応じて書き換える
server_name=localhost
sudo sed -i -e "3 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/default.conf
sudo sed -i -e "4 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/default.conf
sudo \cp -f /home/ctf/CTFd_for_AWS/nginx/default.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx

# ssl証明書の設定
sudo apt install -y letsencrypt
sudo letsencrypt certonly --webroot --webroot-path /usr/share/nginx/html -d $server_name

sudo sed -i -e "5 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/ssl.conf
sudo sed -i -e "6 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/ssl.conf
sudo sed -i -e "21 s/ec2-[0-9]*-[0-9]*-[0-9]*-[0-9]*\.[0-9a-zA-Z]*-[0-9a-zA-Z]*-[0-9]*\.compute\.amazonaws\.com/`cat /home/ctf/CTF_for_AWS/PublicDNS`/g" /etc/nginx/conf.d/ssl.conf
sudo \cp -f /home/ctf/CTFd_for_AWS/nginx/ssl.conf /etc/nginx/conf.d/ssl.conf
sudo systemctl restart nginx

# PHPのインストール
sudo apt install -y php php-fpm php-mysql php-gettext php-common php-mbstring
sudo apt install -y php7.2-sqlite3
sudo sed -i -e "778 s/;cgi\.fix_pathinfo=1/cgi\.fix_pathinfo=0/g" /etc/php/7.2/fpm/php.ini
sudo sed -i -e "827 s/2M/40M/g" /etc/php/7.2/fpm/php.ini
sudo sed -i -e "925 s/;//g" /etc/php/7.2/fpm/php.ini
sudo sed -i -e "23 s/www-data/nginx/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i -e "24 s/www-data/nginx/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i -e "47 s/www-data/nginx/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i -e "48 s/www-data/nginx/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo apt update
sudo apt -y upgrade

sudo stop apache2
sudo disable apache2

sudo systemctl restart nginx
