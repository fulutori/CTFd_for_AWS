#!/bin/bash
adduser ctf
gpasswd -a ctf sudo
mkdir /home/ctf/.ssh
mv /home/ubuntu/.ssh/authorized_keys /home/ctf/.ssh/
chown -R ctf:ctf /home/ctf/.ssh