#!/bin/bash
sudo adduser ctf
sudo gpasswd -a ctf sudo
su - ctf
mkdir /home/ctf/.ssh
mv /home/ubuntu/.ssh/authorized_keys /home/ctf/.ssh/
chown -R ctf:ctf /home/ctf/.ssh