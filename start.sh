#!/bin/bash
/usr/bin/python3 /home/ctf/CTFd_for_AWS/get_ipv4.py
screen -dmS ctfd
screen -S ctfd -X stuff '/usr/bin/python3 /home/ctf/CTFd/serve.py'`echo -ne '\015'`