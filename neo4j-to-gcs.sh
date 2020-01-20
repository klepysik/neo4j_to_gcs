#!/bin/bash
#check who is master
GETMYEXTIP=`curl -XGET http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip --header "Metadata-Flavor: Google"`
GETMASTER=`host neo4j.service.consul | cut -d" " -f4`

if [ "$GETMYEXTIP" == "$GETMASTER" ]
then
  echo "Running on master, skipping"
        exit
fi
#check what is the latest backup in the /root/neobackup/backup directory
backup_name=$(ls -rt1 /root/neobackup/backup/ | tail -1 | grep .tar )
backup_local_path=${NEO4J_GCS_LOCAL_PATH:-"/root/neobackup/backup"}
backup_bucket_name=${NEO4J_GCS_UPLOAD_BUCKET:-"/neo_backup/xxx"}

if [ -z ${NEO4J_GCS_UPLOAD_BUCKET+x} ];
then echo "ERROR - Please set the NEO4J_GCS_UPLOAD_BUCKET environment variable" && exit 1;
fi

# upload backup to google

gsutil -m cp -r ${backup_local_path}/$backup_name gs://${backup_bucket_name}/$backup_name


# signalfx send success

result=$(find . -mmin -60 -type f -exec ls -l {} + | wc -l);
curl --request POST --url https://ingest.signalfx.com/v2/datapoint --header 'Cache-Control: no-cache' --header 'Content-Type: application/json' --header 'X-SF-TOKEN: your token' --data '{"gauge": [{"metric": "google.bkp", "dimensions":{"server": "'"$HOSTNAME"'","environment":"xxx"}, "value": '$result'}]}'