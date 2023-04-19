#!/bin/sh

set -ex 

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
    #newgrp docker
    echo "Finished installing docker"
}

install_node() {
    sudo yum install -y nodejs npm
}

install_node
install_docker

