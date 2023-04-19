#!/bin/sh

#-----------------------------------------------------------------------------------------------------------
# Common setup for all Teamcenter servers in CentOS.
#-----------------------------------------------------------------------------------------------------------

create_user() {
    #Create a new user "tc"
    sudo useradd -m -d /home/tc -s /bin/bash tc
    echo 'tc    ALL=(ALL)    NOPASSWD: ALL' | sudo tee /etc/sudoers.d/tc
    sudo mkdir -p /home/tc/.ssh
    sudo cp -R /home/centos/.ssh/authorized_keys /home/tc/.ssh/authorized_keys
    sudo chmod 700 /home/tc/.ssh
    sudo chmod 600 /home/tc/.ssh/authorized_keys
    sudo chown -R tc:tc /home/tc/.ssh
    #Add user tc to group tc
    sudo usermod -aG tc tc
}

install_base_packages() {
    sudo yum -y install epel-release
    sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm # Needed by jq
    sudo yum -y install unzip ksh java-11-openjdk java-11-openjdk-devel nc bind-utils libaio jq wget python3
    sudo pip3 install boto3
    sudo pip3 install requests

    # Install aws-cli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -qq -o awscliv2.zip
    sudo ./aws/install

    # Install SSM agent
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
}

mount_software_repo() {
    DEST=$1
    echo "Mounting Software Repo to $DEST"
    sudo mkdir -p "$DEST"
    UUID=$(sudo blkid | grep "nvme1" | sed 's|.*UUID="||; s|".*||')
    sudo echo "UUID=$UUID $DEST  xfs  defaults,nofail  0  2" | sudo tee --append /etc/fstab
    sudo mount -a
}

set_env_vars() {
    sudo echo "export JAVA_HOME=/usr/lib/jvm/java" | sudo tee /etc/profile.d/java.sh
    sudo echo "export JRE64_HOME=/usr/lib/jvm/java" | sudo tee --append /etc/profile.d/java.sh
    sudo echo "export TC_ROOT=/usr/Siemens/Teamcenter13/teamcenter_root" | sudo tee /etc/profile.d/tc.sh
    sudo echo "export PATH=$PATH:/usr/local/bin" | sudo tee /etc/profile.d/path.sh # Needed for AWS cli to be available to all users
}

fix_locale() {
    echo "LANG=en_US.utf-8" | sudo tee --append /etc/environment
    echo "LC_ALL=en_US.utf-8" | sudo tee --append /etc/environment
}

install_kubectl() {
    sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x kubectl
    sudo mv kubectl /usr/local/bin
    echo "kubectl installed"
}

install_amazon_cloudwatch_agent(){
    sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm
    sudo rpm -U ./amazon-cloudwatch-agent.rpm
    sudo mv /tmp/config.json /opt/aws/amazon-cloudwatch-agent/etc/common-teamcenter-config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/common-teamcenter-config.json 
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo systemctl start amazon-cloudwatch-agent.service
}



install_base_packages
create_user
mount_software_repo "/software" 
set_env_vars
fix_locale
install_kubectl
install_amazon_cloudwatch_agent

