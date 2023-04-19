#!/bin/bash

echo "============ Mounting OpenZFS ============" >> /tmp/user_data.log 2>&1

FSX_DNS=$(cat /tmp/fsx_dns)
echo "${FSX_DNS}:/fsx   /fsx    nfs      defaults        0 0" | tee -a /etc/fstab > /dev/null

echo "************* Mounting ${FSX_DNS} *************" >> /tmp/user_data.log 2>&1
mount -t nfs -o nfsvers=4.1 ${FSX_DNS}:/fsx/ /fsx >> /tmp/user_data.log 2>&1

setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config > /dev/null

echo "============ NIS users ============" >> /tmp/user_data.log 2>&1
ypdomainname lsfusers
echo "NISDOMAIN=lsfusers
YPSERV_ARGS=\"-p 955\"
YPXFRD_ARGS=\"-p 956\"
NOZEROCONF=yes" | tee -a /etc/sysconfig/network

MASTER_HOSTNAME=$(cat /fsx/master_hostname)
echo "ypserver ${MASTER_HOSTNAME}" | tee -a  /etc/yp.conf

systemctl restart ypbind.service

FLAGS="--enablenis --nisdomain=lsfusers --nisserver=${MASTER_HOSTNAME} --enablemkhomedir --update"

authconfig ${FLAGS}

LSF_TOP="/usr/share/lsf"

echo "============ Profile ============" >> /tmp/user_data.log 2>&1
echo "source /usr/share/lsf/conf/profile.lsf" | tee -a /etc/profile > /dev/null

echo "============ Host Setup ============"
cd /usr/share/lsf/10.1/install
./hostsetup --top="/usr/share/lsf" --boot="y" >> /tmp/user_data.log 2>&1

echo "============ Daemons Start ============"
source /usr/share/lsf/conf/profile.lsf
lsadmin limstartup >> /tmp/user_data.log 2>&1
