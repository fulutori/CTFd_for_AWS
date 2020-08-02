#!/bin/bash

# 実行時はctfユーザーを作成しておく
# sudo adduser ctf
# sudo gpasswd -a ctf sudo
# su - ctf


# 各種設定 ※環境に応じて書き換える
server_name=localhost
email=admin@test.com

sudo apt update
sudo apt -y upgrade

# CTFdのインストール
git clone https://github.com/CTFd/CTFd.git
sudo apt insatll python3-pip
pip3 install -r /home/ctf/CTFd/requirements.txt
sed -i -e "31 s/127\.0\.0\.1/0\.0\.0\.0/g" /home/ctf/CTFd/serve.py
sed -i -e "31 s/args\.port/8000/g" /home/ctf/CTFd/serve.py

# 最初にIPv4を取得しておく
python3 /home/ctf/CTFd_for_AWS/get_ipv4.py

# ドメインを設定後nginxは停止させておく
sudo apt install -y nginx
sudo sed -i -e "3 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/default.conf
sudo sed -i -e "4 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/default.conf
sudo \cp -f /home/ctf/CTFd_for_AWS/nginx/default.conf /etc/nginx/conf.d/default.conf
sudo systemctl stop nginx

# ssl証明書の設定
git clone https://github.com/certbot/certbot
sudo /home/ctf/certbot/certbot-auto certonly --standalone -d $server_name -m $email --agree-tos -n

sudo sed -i -e "5 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/ssl.conf
sudo sed -i -e "6 s/localhost/$server_name/g" /home/ctf/CTFd_for_AWS/nginx/ssl.conf
sudo sed -i -e "21 s/ec2-[0-9]*-[0-9]*-[0-9]*-[0-9]*\.[0-9a-zA-Z]*-[0-9a-zA-Z]*-[0-9]*\.compute\.amazonaws\.com/`cat /home/ctf/CTF_for_AWS/PublicDNS`/g" /etc/nginx/conf.d/ssl.conf

sudo cp -f /home/ctf/CTFd_for_AWS/nginx/ssl.conf /etc/nginx/conf.d/ssl.conf
sudo sed -i -e "4 s/#//g" /etc/nginx/conf.d/default.conf
sudo systemctl start nginx

screen -S ctfd -X stuff '/usr/bin/python3 /home/ctf/CTFd/serve.py'