python3 /home/ctf/CTFd_for_AWS/get_ipv4.py
sed -i -e "21 s/ec2-[0-9]*-[0-9]*-[0-9]*-[0-9]*\.[0-9a-zA-Z]*-[0-9a-zA-Z]*-[0-9]*\.compute\.amazonaws\.com/`cat /home/ctf/PublicDNS`/g" /etc/nginx/conf.d/ssl.conf
systemctl restart nginx