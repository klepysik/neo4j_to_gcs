#!/bin/bash

GETMYEXTIP=`curl -XGET http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip --header "Metadata-Flavor: Google"`
GETMASTER=`host neo4j.service.consul | cut -d" " -f4`

#check if master
if [ "$GETMYEXTIP" == "$GETMASTER" ]
then
  echo "Running on master, skipping"
        exit
fi

NOW=name_neo4j-`date +"%y-%m-%d-%Hh%M"`
mkdir /root/neobackup/backup/$NOW
/usr/share/neo4j/bin/neo4j-backup -host localhost -to /root/neobackup/backup/$NOW
SUCCESS=$?
tar --exclude='*.tar.gz' -czf /root/neobackup/backup/neo4j_$NOW.tar.gz /root/neobackup/backup/$NOW  && rm -Rf /root/neobackup/backup/$NOW
find /root/neobackup/backup -mmin +1200 -exec rm -rf {} \;
curl --request POST --url https://ingest.signalfx.com/v2/datapoint --header 'Cache-Control: no-cache' --header 'Content-Type: application/json' --header 'X-SF-TOKEN: your token' --data '{"gauge": [{"metric": "neo.backup", "dimensions":{"server": "'"$HOSTNAME"'","environment":"xxx"}, "value": '$SUCCESS'}]}'


