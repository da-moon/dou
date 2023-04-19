#!/bin/sh

set -ex 

install_extra_packages() {
    sudo yum install -y haveged python-boto3 yum-cron perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64 python2-botocore python2-simplejson dnsmasq
}

install_docker() {
    echo "Installing docker"
    sudo yum install -y yum-utils
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce-20.10.10 docker-ce-cli-20.10.10 containerd.io docker-compose-plugin
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker centos
    sudo usermod -aG docker tc
    #newgrp docker
    echo "Finished installing docker"
}

install_node() {
    sudo yum install -y nodejs npm
}

setup_file_system() {
    sudo mkdir -p ${FILE_REPO_PATH}
    sudo chown -R tc:tc ${FILE_REPO_PATH}
}

replace_java() {
    # Use exactly the java version 11.0.9, because that is the version
    # used by the docker containers
    mkdir -p /tmp/java
    cd /tmp/java
    curl https://builds.openlogic.com/downloadJDK/openlogic-openjdk/11.0.9.1%2B1/openlogic-openjdk-11.0.9.1%2B1-linux-x64.tar.gz --output jdk.tar.gz
    tar -zxvf jdk.tar.gz
    sudo mv open* /usr/lib/jvm
    cd /usr/lib/jvm
    sudo rm java
    sudo ln -s open* java
    cd /etc/alternatives
    sudo rm java
    sudo ln -s /usr/lib/jvm/java/bin/java java
    sudo rm /etc/profile.d/java.sh
    sudo echo "export JAVA_HOME=/usr/lib/jvm/java" | sudo tee /etc/profile.d/java.sh
    sudo echo "export JRE64_HOME=/usr/lib/jvm/java" | sudo tee --append /etc/profile.d/java.sh
    export JAVA_HOME=/usr/lib/jvm/java
    export JRE64_HOME=/usr/lib/jvm/java
}

install_extra_packages
install_node
install_docker
setup_file_system
replace_java

