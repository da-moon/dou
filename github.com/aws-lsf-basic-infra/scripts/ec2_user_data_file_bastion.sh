#!/bin/bash

# Update terminal color to Blue
echo 'export PS1="\e[1;34m[\u@\h \W]\$ \e[m"' | tee -a  /etc/profile.d/bash_profile.sh > /dev/null

# Worker script
yum -y install nano >> /tmp/user_data.log 2>&1
yum -y install ed >> /tmp/user_data.log 2>&1
yum -y install libnsl >> /tmp/user_data.log 2>&1
yum -y install unzip >> /tmp/user_data.log 2>&1
yum -y install ypbind yp-tools authconfig-gtk >> /tmp/user_data.log 2>&1

echo "============ install aws cli ============" >> /tmp/user_data.log 2>&1

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" >> /tmp/user_data.log 2>&1
unzip awscliv2.zip >> /dev/null
./aws/install >> /tmp/user_data.log 2>&1

echo "============ Packages installed ============" >> /tmp/user_data.log 2>&1

echo "============ Mounting OpenZFS ============" >> /tmp/user_data.log 2>&1

yum -y install nfs-utils

mkdir /fsx

FSX_DNS=$(cat /tmp/fsx_dns)

echo "${FSX_DNS}:/fsx   /fsx    nfs      defaults        0 0" | tee -a /etc/fstab > /dev/null

echo "************* Mounting ${FSX_DNS} *************" >> /tmp/user_data.log 2>&1

mount -t nfs -o nfsvers=4.1 ${FSX_DNS}:/fsx/ /fsx >> /tmp/user_data.log 2>&1

echo "Cleaning FSX... " >> /tmp/user_data.log 2>&1
rm -rf /fsx/*

echo "============ File System Ready ============" >> /tmp/user_data.log 2>&1

groupadd edagroup >> /tmp/user_data.log 2>&1

adduser lsfadmin       
usermod -a -G edagroup lsfadmin 

setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config > /dev/null

echo "============ NIS users ============" >> /tmp/user_data.log 2>&1
ypdomainname lsfusers
echo "NISDOMAIN=lsfusers
YPSERV_ARGS=\"-p 955\"
YPXFRD_ARGS=\"-p 956\"" | tee -a /etc/sysconfig/network

until [ -f /fsx/master_hostname ]
do
     echo "Waiting for NIS master" >> /tmp/user_data.log 2>&1
     sleep 5
done

MASTER_HOSTNAME=$(cat /fsx/master_hostname)
echo "ypserver ${MASTER_HOSTNAME}" | tee -a  /etc/yp.conf

systemctl restart ypbind.service

FLAGS="--enablenis --nisdomain=lsfusers --nisserver=${MASTER_HOSTNAME} --enablemkhomedir --update"

authconfig ${FLAGS}

# echo "============ Exporting hostname ============" >> /tmp/user_data.log 2>&1
# echo "${HOSTNAME%.*.*.*}" | tee -a /fsx/bastion_ip

echo "============ Download file from s3 ============" >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lsfinstall_linux_x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z >> /tmp/user_data.log 2>&1
aws s3 cp s3://eda-ibm-lsf-installers/lsf_std_entitlement.dat /usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat >> /tmp/user_data.log 2>&1

echo "============ Files moved ============" >> /tmp/user_data.log 2>&1

tar -zxvf /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z -C /usr/share/lsf_files >> /dev/null

echo "============ Installation files ready ============" >> /tmp/user_data.log 2>&1

# echo "============ Waiting for LSF Master ============" >> /tmp/user_data.log 2>&1
# until [ -f /fsx/master_ip ]
# do
#      sleep 5
# done
echo "============ LSF Master ready ============" >> /tmp/user_data.log 2>&1

# LSF_MASTER_IP=$(cat /fsx/master_ip)
# Creating LSF config file
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

# Setting up the host
cd /usr/share/lsf/10.1/install && ./hostsetup --top="/usr/share/lsf" --boot="y"

echo "============ Host setup ready ============" >> /tmp/user_data.log 2>&1

echo "============ Installing JRE and Patching ============" >> /tmp/user_data.log 2>&1

yum -y install java-1.8.0-openjdk-devel

cd /usr/share/lsf_files/lsf10.1_lsfinstall/

./patchinstall -f /usr/share/lsf/conf/profile.lsf /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z --silent

echo "============ Patch Completed ============" >> /tmp/user_data.log 2>&1

# Adding LSF env vars to the profile
echo "source /usr/share/lsf/conf/profile.lsf" | tee -a /etc/profile > /dev/null

echo "============ Profile added ============" >> /tmp/user_data.log 2>&1

echo "============ Succesfully Executed User Data ============" >> /tmp/user_data.log 2>&1

# Restarting to start the daemons
shutdown --reboot +1