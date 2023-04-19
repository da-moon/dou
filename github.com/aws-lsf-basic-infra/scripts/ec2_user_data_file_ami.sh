# !/bin/bash

echo "============ User Color ============"
echo 'export PS1="\e[1;35m[\u@\h \W]\$ \e[m"' | sudo tee -a  /etc/profile.d/bash_profile.sh

. /etc/profile.d/bash_profile.sh

echo "============ Packages Installation ============"
# Worker script  
sudo yum -y install ed > /dev/null
sudo yum -y install libnsl > /dev/null
sudo yum -y install unzip > /dev/null
sudo yum -y install nfs-utils > /dev/null
sudo yum -y install ypbind yp-tools authconfig-gtk

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null
sudo unzip awscliv2.zip -d /usr/share/ > /dev/null
cd /usr/share/
sudo ./aws/install

sudo groupadd edagroup  

sudo adduser lsfadmin    
sudo usermod -a -G edagroup lsfadmin 

echo "============ Folders Creation ============" 
sudo mkdir /fsx
sudo mkdir /usr/share/lsf_files    
sudo mkdir /usr/share/lsf_files/lsf_distrib    

echo "============ S3 Files Download ============"    
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z /home/ec2-user/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z    
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lnx310-lib217-x86_64.tar.Z /home/ec2-user/lsf10.1_lnx310-lib217-x86_64.tar.Z    
aws s3 cp s3://eda-ibm-lsf-installers/lsf10.1_lsfinstall_linux_x86_64.tar.Z /home/ec2-user/lsf10.1_lsfinstall_linux_x86_64.tar.Z    
aws s3 cp s3://eda-ibm-lsf-installers/lsf_std_entitlement.dat /home/ec2-user/lsf_std_entitlement.dat    

sudo mv /home/ec2-user/lsf10.1_lsfinstall_linux_x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z 
sudo mv /home/ec2-user/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z
sudo mv /home/ec2-user/lsf10.1_lnx310-lib217-x86_64.tar.Z /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64.tar.Z
sudo mv /home/ec2-user/lsf_std_entitlement.dat /usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat  

sudo tar -zxvf /usr/share/lsf_files/lsf10.1_lsfinstall_linux_x86_64.tar.Z -C /usr/share/lsf_files

echo "============ LSF Installation ============"
LSF_MASTER_IP="ip-10-0-1-51"

echo "LSF_TOP=\"/usr/share/lsf\"
LSF_ADMINS=\"lsfadmin ec2-user\"
LSF_CLUSTER_NAME=\"verification_cluster\"
LSF_MASTER_LIST=\"${LSF_MASTER_IP}\"
LSF_SERVER_HOSTS=\"${LSF_MASTER_IP}\"
LSF_ENTITLEMENT_FILE=\"/usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat\"
LSF_TARDIR=\"/usr/share/lsf_files/\"
LSF_LOCAL_RESOURCES=\"[resource awshost] [resource define_ncpus_threads] [resourcemap spot*pricing]\"
LSF_LIM_PORT=\"7869\"
CONFIGURATION_TEMPLATE=\"HIGH_THROUGHPUT\"
SILENT_INSTALL=\"Y\"
LSF_SILENT_INSTALL_TARLIST=\"All\"
ACCEPT_LICENSE=\"Y\"
ENABLE_EGO=\"Y\"
EGO_DAEMON_CONTROL=\"Y\"
ENABLE_DYNAMIC_HOSTS=\"Y\"" | sudo tee -a /usr/share/lsf_files/lsf10.1_lsfinstall/custom_install.config > /dev/null

cd /usr/share/lsf_files/lsf10.1_lsfinstall/ 
sudo ./lsfinstall -s -f custom_install.config

echo "============ JRE and Patch ============" 
sudo yum -y install java-1.8.0-openjdk-devel
cd /usr/share/lsf_files/lsf10.1_lsfinstall/
sudo ./patchinstall -f /usr/share/lsf/conf/profile.lsf /usr/share/lsf_files/lsf10.1_lnx310-lib217-x86_64-600488.tar.Z --silent
