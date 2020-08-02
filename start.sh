#!/bin/bash
screen -dmS ctfd
screen -S ctfd -X stuff '/usr/bin/python3 /home/ctf/CTFd/serve.py'`echo -ne '\015'`