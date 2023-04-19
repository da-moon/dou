#!/bin/sh

# Install base packages
sudo apt update -y
sudo apt install nfs-common unzip openjdk-11-jre-headless ksh net-tools -y
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Automount EFS on /data
sudo mkdir -p /data
sudo echo "${efs_id}.efs.${region}.amazonaws.com:/ /data nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab
sudo mount -a
sudo chmod -R 777 /data

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Deployment Center
#sudo mkdir -p /data/downloads/DeploymentCenter
#aws s3 cp s3://teamcenter/DeploymentCenter_4.2.0.2.zip /data/downloads
#cd /data/downloads
#unzip -d DeploymentCenter DeploymentCenter_4.2.0.2.zip 
#cd /data/downloads/DeploymentCenter/deployment_center
#./deployment_center.sh -install -inputFile=install_config.properties

# Run Deployment Center
