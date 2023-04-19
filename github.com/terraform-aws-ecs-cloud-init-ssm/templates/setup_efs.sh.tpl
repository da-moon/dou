#!/bin/bash

## install EFS requirements
sudo yum install -y nfs-utils

### Create /efs dir for mounting EFS share
sudo mkdir /efs

### Add EFS share to /etc/fstab
echo "${efs_address}:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab

### Mount EFS Share
sudo mount -a

######## Create airflow directories on EFS if they don't exist #########
mkdir -p /efs/airflow/config
mkdir -p /efs/airflow/logs
mkdir -p /efs/airflow/dags
mkdir -p /efs/airflow/plugins

### Change ownership of all airflow directories to the UID/GID of the airflow user in the airflow container
### We know this user always has a UID of 1000, so this UID must be the same as the UID on this folder, regardless
### of which user that UID actually maps to (if any)
### See: http://stackoverflow.com/questions/29245216/write-in-shared-volumes-docker

sudo chown -R 1000:1000 /efs/airflow

### Restart Docker and ECS
### THIS IS NECESSARY OR YOUR EFS VOLUME WILL NOT BE MOUNTABLE IF THE DAEMON STARTS BEFORE THE VOLUME IS MOUNTED.

sudo service docker restart
sleep 10
sudo stop ecs
sleep 10
sudo start ecs