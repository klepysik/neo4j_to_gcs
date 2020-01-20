
import paramiko

//35.193.151.21
username = okurtzer
password =
hostname = input ("what is the server IPß")
port = 22

ssh = paramiko.SSHClient()

ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

ssh.connect('<hostname>', username='<username>', password='<password>', key_filename='/Users/olgakurtzer/.ssh/id_rsa')
# command1 = "df -kh"

stdin, stdout, stderr = ssh.exec_command('ls')
print stdout.readlines()
ssh.close()r


=================
#!/usr/bin/env python
""""
    This script contains modules to read and write to signalfx
"""
import signalfx
from sys import exc_info as info
from devops_utils.logger import Logger


# Send metrics to signalfx
def send_signalfx(token, metric):
    try:
        sfx = signalfx.SignalFx()
        ingest = sfx.ingest(token)

        ingest.send(gauges=metric)
        ingest.stop()
    except:
        Logger.exception("Exception - can't connect Signalfx: {}\n".format(info()[1]))
