#!/bin/bash

# Update terminal color to Green
echo 'export PS1="\e[1;32m[\u@\h \W]\$ \e[m"' | tee -a  /etc/profile.d/bash_profile.sh > /dev/null

# Master script
yum -y install nano >> /tmp/user_data.log 2>&1
yum -y install ed >> /tmp/user_data.log 2>&1
yum -y install libnsl >> /tmp/user_data.log 2>&1
yum -y install unzip >> /tmp/user_data.log 2>&1
yum -y install ypserv rpcbind yp-tools nss-pam-ldapd >> /tmp/user_data.log 2>&1
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >> /tmp/user_data.log 2>&1
yum -y install jq >> /tmp/user_data.log 2>&1

echo "============ install aws cli ============" >> /tmp/user_data.log 2>&1

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" >> /tmp/user_data.log 2>&1
unzip awscliv2.zip > /dev/null
./aws/install >> /tmp/user_data.log 2>&1

echo "============ Packages installed ============" >> /tmp/user_data.log 2>&1

echo "============ Mounting OpenZFS ============" >> /tmp/user_data.log 2>&1

yum -y install nfs-utils

mkdir /fsx

FSX_DNS=$(cat /tmp/fsx_dns)

echo "${FSX_DNS}:/fsx   /fsx    nfs      defaults        0 0" | tee -a /etc/fstab > /dev/null

echo "************* Mounting ${FSX_DNS} *************" >> /tmp/user_data.log 2>&1
mount -t nfs -o nfsvers=4.1 ${FSX_DNS}:/fsx/ /fsx >> /tmp/user_data.log 2>&1

echo "============ File System Ready ============" >> /tmp/user_data.log 2>&1

echo "============ Configuring Users ============" >> /tmp/user_data.log 2>&1

setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config > /dev/null

groupadd edagroup >> /tmp/user_data.log 2>&1

adduser lsfadmin    
usermod -a -G edagroup lsfadmin 

adduser -d /fsx/edauser1 edauser1 
echo "edauser1" | passwd --stdin edauser1 
mkdir -p /fsx/edauser1/.ssh 
ssh-keygen -q -f /fsx/edauser1/.ssh/id_rsa -N ""
cp /fsx/edauser1/.ssh/id_rsa.pub /fsx/edauser1/.ssh/authorized_keys
chown -R edauser1:edauser1 /fsx/edauser1/.ssh 
chmod 700 /fsx/edauser1/.ssh
chmod 400 /fsx/edauser1/.ssh/authorized_keys
usermod -a -G edagroup edauser1

adduser -d /fsx/edauser2 edauser2 
echo "edauser2" | passwd --stdin edauser2 
mkdir -p /fsx/edauser2/.ssh 
ssh-keygen -q -f /fsx/edauser2/.ssh/id_rsa -N ""
cp /fsx/edauser2/.ssh/id_rsa.pub /fsx/edauser2/.ssh/authorized_keys
chown -R edauser2:edauser2 /fsx/edauser2/.ssh 
chmod 700 /fsx/edauser2/.ssh
chmod 400 /fsx/edauser2/.ssh/authorized_keys
usermod -a -G edagroup edauser2

echo "============ Users created ============" >> /tmp/user_data.log 2>&1

echo "============ NIS ============" >> /tmp/user_data.log 2>&1
ypdomainname lsfusers
echo "NISDOMAIN=lsfusers
YPSERV_ARGS=\"-p 955\"
YPXFRD_ARGS=\"-p 956\"" | tee -a /etc/sysconfig/network

touch /var/yp/securenets

echo "ypserver ${HOSTNAME}" | tee -a  /etc/yp.conf

systemctl enable rpcbind ypserv ypxfrd yppasswdd >> /tmp/user_data.log 2>&1

systemctl start rpcbind ypserv ypxfrd yppasswdd >> /tmp/user_data.log 2>&1

cd /var/yp

make >> /tmp/user_data.log 2>&1

cd

echo "yppasswdd_args=\"-p 957\"" | tee -a /etc/sysconfig/yppasswdd

systemctl restart rpcbind ypserv ypxfrd yppasswdd

echo "${HOSTNAME}" | tee -a /fsx/master_hostname

echo "============ Exporting hostname ============" >> /tmp/user_data.log 2>&1

# if [ -f /fsx/master_ip ]
# then
#      rm -rf /fsx/master_ip
# fi

# echo "${HOSTNAME%.*.*.*}" | tee -a /fsx/master_ip

echo "============ Download file from s3 ============" >> /tmp/user_data.log 2>&1

aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lsfinstall_linux_x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf_std_entitlement.dat /usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat >> /tmp/user_data.log 2>&1

mkdir /home/ec2-user/aws >> /tmp/user_data.log 2>&1

echo "============ Folders created ============" >> /tmp/user_data.log 2>&1

tar -zxvf /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z -C /usr/share/lsf_files > /dev/null

echo "============ Installation files ready ============" >> /tmp/user_data.log 2>&1

# Creating LSF config file
# LSF_BASTION_IP=$(cat /fsx/bastion_ip)
echo "LSF_TOP=\"/usr/share/lsf\"
LSF_ADMINS=\"lsfadmin ec2-user\"
LSF_CLUSTER_NAME=\"verification_cluster\"
LSF_MASTER_LIST=\"ip-10-0-1-51\"
LSF_ADD_CLIENTS=\"ip-10-0-101-50\"
LSF_ENTITLEMENT_FILE=\"/usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat\"
LSF_TARDIR=\"/usr/share/lsf_files/\"
CONFIGURATION_TEMPLATE=\"HIGH_THROUGHPUT\"
SILENT_INSTALL=\"Y\"
LSF_SILENT_INSTALL_TARLIST=\"All\"
ACCEPT_LICENSE=\"Y\"
ENABLE_EGO=\"Y\"
EGO_DAEMON_CONTROL=\"Y\"
ENABLE_DYNAMIC_HOSTS=\"Y\"" | tee -a /usr/share/lsf_files/lsf10.1_lsfinstall/custom_install.config > /dev/null

echo "============ Custom Installation File ready ============" >> /tmp/user_data.log 2>&1

# Installing LSF silent mode
cd /usr/share/lsf_files/lsf10.1_lsfinstall/ && ./lsfinstall -f custom_install.config

echo "============ LSF Installed ============" >> /tmp/user_data.log 2>&1

# echo "============ License Scheduler Installation ============" >> /tmp/user_data.log 2>&1

# cd /usr/share/lsf_files/

# wget https://eda-ibm-lsf-installers.s3.us-west-1.amazonaws.com/license_scheduler/lsf10.1_licsched_lnx310-x64.tar.Z

# tar -zxvf /usr/share/lsf_files/lsf10.1_licsched_lnx310-x64.tar.Z -C /usr/share/lsf_files

# cd /usr/share/lsf_files/lsf10.1_licsched_linux3.10-glibc2.17-x86_64

# mv /usr/share/lsf_files/lsf10.1_licsched_linux3.10-glibc2.17-x86_64/setup.config /usr/share/lsf_files/lsf10.1_licsched_linux3.10-glibc2.17-x86_64/setup.config.bak

# echo "LS_TOP=\"/usr/share/lsf\"
# LS_ADMIN=\"lsfadmin ec2-user\"
# LS_HOSTS=\"ip-10-0-101-50\"
# # LS_LMSTAT_PATH=\"/usr/bin\"
# NON_SHARED_SERVER=\"Y\"
# SILENT_INSTALL=\"N\"" | tee -a /usr/share/lsf_files/lsf10.1_licsched_linux3.10-glibc2.17-x86_64/setup.config > /dev/null

# ./setup

# source /usr/share/lsf/conf/profile.lsf

# echo "LSF_LIC_SCHED_HOSTS=\"${HOSTNAME%.*.*.*}\"" | tee -a /usr/share/lsf/conf/lsf.conf > /dev/null

# lsadmin reconfig

# badmin mbdrestart

# echo "============ License Scheduler Ready ============" >> /tmp/user_data.log 2>&1

echo "Begin UserGroup
GROUP_NAME      GROUP_MEMBER            USER_SHARES
edagroup        (all)                   () 
system          (all)                   ()
End UserGroup" | tee -a /usr/share/lsf/conf/lsb.users > /dev/null

echo "============ Installing JRE and Patching ============" >> /tmp/user_data.log 2>&1

yum -y install java-1.8.0-openjdk-devel

cd /usr/share/lsf_files/lsf10.1_lsfinstall/

./patchinstall -f /usr/share/lsf/conf/profile.lsf /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z --silent

echo "============ Patch Completed ============" >> /tmp/user_data.log 2>&1

echo "============ Enabling mosquitto and logs ============" >> /tmp/user_data.log 2>&1

echo "LSF_MQ_BROKER_HOSTS=\"${HOSTNAME%.*.*.*}\"" | tee -a /usr/share/lsf/conf/lsf.conf
echo "LSB_DEBUG_MBD=\"LC2_RC\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSB_DEBUG_SCH=\"LC2_RC\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSB_DEBUG_EBROKERD=\"LC2_RC\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSB_RC_EXTERNAL_HOST_IDLE_TIME=\"5\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSF_DYNAMIC_HOST_TIMEOUT=\"10m\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSB_RC_EXTERNAL_HOST_FLAG=\"awshost\"" | sudo tee -a /usr/share/lsf/conf/lsf.conf
echo "LSF_REG_FLOAT_HOSTS=Y" | sudo tee -a /usr/share/lsf/conf/lsf.conf

echo "============ Preparing aws resource connector files ============" >> /tmp/user_data.log 2>&1

mkdir /usr/share/lsf/conf/resource_connector/aws
mkdir /usr/share/lsf/conf/resource_connector/aws/conf


CUSTOM_AMI=$(jq -r '.builds[-1].artifact_id' /home/ec2-user/resource_connector/packer_manifest.json | cut -d ":" -f2)
sed -i "s/_AMI_/${CUSTOM_AMI}/g" /home/ec2-user/resource_connector/awsprov_templates.json

mv /home/ec2-user/resource_connector/awsprov_config.json /usr/share/lsf/conf/resource_connector/aws/conf/awsprov_config.json
mv /home/ec2-user/resource_connector/ec2_user_data_file_spot.sh /usr/share/lsf/10.1/resource_connector/aws/scripts/user_data.sh

mv /home/ec2-user/resource_connector/awsprov_templates.json /usr/share/lsf/conf/resource_connector/aws/conf/awsprov_templates.json
mv /home/ec2-user/resource_connector/hostProviders.json /usr/share/lsf/conf/resource_connector/hostProviders.json


sed -i 's/^LSF_HOST_ADDR_RANGE=*.*.*.*/LSF_HOST_ADDR_RANGE=10.0.1-2.*/g' /usr/share/lsf/conf/lsf.cluster.verification_cluster > /dev/null
sed -i '/^End Resource/i awshost    Boolean    ()       ()       (instances from AWS)' /usr/share/lsf/conf/lsf.shared > /dev/null
sed -i '/^End Resource/i pricing        String   ()       ()         (Pricing option: spot/ondemand)' /usr/share/lsf/conf/lsf.shared > /dev/null


sed -i '/^End PluginModule/i schmod_demand   ()      ()' /usr/share/lsf/conf/lsbatch/verification_cluster/configdir/lsb.modules > /dev/null

echo "Begin Queue
QUEUE_NAME   = awsexample
DESCRIPTION  = AWS queue
RC_HOSTS  = awshost
End Queue" | tee -a /usr/share/lsf/conf/lsbatch/verification_cluster/configdir/lsb.queues > /dev/null

# Setting up the host
cd /usr/share/lsf/10.1/install && ./hostsetup --top="/usr/share/lsf" --boot="y"

echo "============ Host setup ready ============" >> /tmp/user_data.log 2>&1

# Adding LSF env vars to the profile
echo "source /usr/share/lsf/conf/profile.lsf" | tee -a /etc/profile > /dev/null

echo "============ Profile added ============" >> /tmp/user_data.log 2>&1

echo "============ Closing Master ============" >> /tmp/user_data.log 2>&1
source /usr/share/lsf/conf/profile.lsf
badmin hclose

# Restarting to start the daemons
shutdown --reboot +1


