#!/bin/sh

set -ex 

mount_software_repo() {
    DEST=$1
    echo "Mounting Software Repo to $DEST"
    sudo mkdir -p "$DEST"
    UUID=$(sudo blkid | grep "nvme1" | sed 's|.*UUID="||; s|".*||')
    sudo echo "UUID=$UUID $DEST  xfs  defaults,nofail  0  2" | sudo tee --append /etc/fstab
    sudo mount -a
}

install_sqlplus() {
    sudo mkdir -p /opt/oracle
    cd /opt/oracle
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -o 'Dpkg::Progress-Fancy="0"' -yq alien libaio1
    sudo curl https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm --output oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm
    sudo curl https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm --output oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm

    sudo alien -i oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm
    sudo alien -i oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm

    sudo sh -c 'echo /usr/lib/oracle/21/client64/lib/ > /etc/ld.so.conf.d/oracle.conf'
    sudo ldconfig
}

create_tc_user() {
    sudo useradd -m -d /home/tc -s /bin/bash tc
    echo 'tc    ALL=(ALL)    NOPASSWD: ALL' | sudo tee /etc/sudoers.d/tc
    sudo mkdir -p /home/tc/.ssh
    sudo cp -R /home/ubuntu/.ssh/authorized_keys /home/tc/.ssh/authorized_keys
    sudo chmod 700 /home/tc/.ssh
    sudo chmod 600 /home/tc/.ssh/authorized_keys
    sudo chown -R tc:tc /home/tc/.ssh
    #Add user tc to group tc
    sudo usermod -aG tc tc
}

install_ssm_agent() {
    sudo snap switch --channel=candidate amazon-ssm-agent
    sudo snap install amazon-ssm-agent --classic
    sudo snap start amazon-ssm-agent
}

install_kubectl() {
    sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x kubectl
    sudo mv kubectl /usr/local/bin
}

# Install base packages
sudo apt-get remove -yq needrestart && \
    sudo apt-get update -yq && \
    sudo apt-get upgrade -yq && \
    sudo apt-get install -o 'Dpkg::Progress-Fancy="0"' -yq nfs-common unzip openjdk-11-jre-headless ksh net-tools xfsprogs jq python3-pip
sudo pip install --user boto3
sudo -H -u ubuntu bash -c 'pip install boto3'

install_ssm_agent

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq -o awscliv2.zip
sudo ./aws/install

# Set hostname
sudo hostnamectl set-hostname ${MACHINE_NAME}
sed "s|127.0.0.1.*|127.0.0.1 localhost ${MACHINE_NAME}|" /etc/hosts > /tmp/hosts
sudo mv /tmp/hosts /etc/hosts


# Common environment variables
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" | sudo tee /etc/profile.d/java.sh
sudo echo "export JRE64_HOME=/usr/lib/jvm/java-11-openjdk-amd64" | sudo tee --append /etc/profile.d/java.sh

mount_software_repo "/software" 
install_sqlplus
install_kubectl
create_tc_user

