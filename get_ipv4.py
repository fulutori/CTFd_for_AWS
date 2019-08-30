import subprocess
result = subprocess.check_output(['curl', '-q', 'http://169.254.169.254/latest/meta-data/public-ipv4']).decode().split('.')
result2 = subprocess.check_output(['curl', '-s', 'http://169.254.169.254/latest/meta-data/placement/availability-zone']).decode()[:-1]
with open('/home/ctf/PublicDNS', 'w') as f:
    f.write('ec2-{}-{}-{}-{}.{}.compute.amazonaws.com'.format(result[0], result[1], result[2], result[3], result2))