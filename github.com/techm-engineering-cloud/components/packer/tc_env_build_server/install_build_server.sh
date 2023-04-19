#!/bin/bash

install_sqlplus() {
    sudo mkdir -p /opt/oracle
    cd /opt/oracle
    sudo curl https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm --output oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm
    sudo curl https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm --output oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm

    sudo rpm -i oracle-instantclient-basic-21.6.0.0.0-1.el8.x86_64.rpm
    sudo rpm -i oracle-instantclient-sqlplus-21.6.0.0.0-1.el8.x86_64.rpm

    sudo sh -c 'echo /usr/lib/oracle/21/client64/lib/ > /etc/ld.so.conf.d/oracle.conf'
    sudo ldconfig
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

install_yq() {
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod a+x /usr/local/bin/yq
    yq --version
    echo "yq installed"
}

install_sqlplus
install_docker
install_node
install_yq

