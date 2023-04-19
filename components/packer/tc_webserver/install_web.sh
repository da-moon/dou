#!/bin/sh

set -ex 

install_jboss() {
    echo "Installing jboss"
    sudo groupadd -r wildfly
    sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly
    WILDFLY_VERSION=15.0.0.Final
    wget https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -P /tmp
    sudo tar xf /tmp/wildfly-$WILDFLY_VERSION.tar.gz -C /opt/
    sudo ln -s /opt/wildfly-$WILDFLY_VERSION /opt/wildfly
    sudo chown -RH wildfly: /opt/wildfly

    echo "Configuring jboss"
    sudo mkdir -p /etc/wildfly
    sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
    sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/
    sudo sh -c 'chmod +x /opt/wildfly/bin/*.sh'
    sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl start wildfly
    sudo systemctl enable wildfly

    # Teamcenter specific instructions
    sudo mkdir -p /logs
    sudo chown -R wildfly:wildfly /logs/

    echo "Finished installing jboss"
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

install_node
install_docker
install_jboss

