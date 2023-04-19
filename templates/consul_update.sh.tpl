#!/bin/bash

set -e

echo 'create tmp file'

FILE_FINAL=/etc/consul.d/consul.json
FILE_TMP=$FILE_FINAL.tmp

echo 'do all sed commands'
sudo sed -i -- "s|{{ datacenter }}|${datacenter}|g" $FILE_TMP
sudo sed -i -- "s|{{ primary_datacenter }}|${primary_datacenter}|g" $FILE_TMP
sudo sed -i -- "s|{{ encrypt_key }}|${encrypt_key}|g" $FILE_TMP
sudo sed -i -- "s|{{ acl_master_token }}|${acl_master_token}|g" $FILE_TMP
sudo sed -i -- "s|{{ acl_agent_token }}|${acl_agent_token}|g" $FILE_TMP
sudo sed -i -- "s|{{ acl_default_token }}|${acl_default_token}|g" $FILE_TMP
sudo sed -i -- "s|{{ consul_bootstrap_expect }}|${consul_bootstrap_expect}|g" $FILE_TMP
sudo sed -i -- "s|{{ cluster_name }}|${cluster_name}|g" $FILE_TMP

echo 'instance type'

METADATA_INSTANCE_ID=`curl http://169.254.169.254/2014-02-25/meta-data/instance-id`
sudo sed -i -- "s|{{ instance_id }}|$METADATA_INSTANCE_ID|g" $FILE_TMP

echo 'set final file from tmp'
sudo mv $FILE_TMP $FILE_FINAL

sudo systemctl start consul

sudo touch ~/consul_credentials.txt
CONSUL_CREDS=~/consul_credentials.txt
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} 
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region    ${AWS_REGION}
sudo echo "acl_master_token: ${acl_master_token}" >> $CONSUL_CREDS
aws s3 cp ~/consul_credentials.txt "s3://${bucket_name}/"

echo "Consul environment updated."

exit 0
