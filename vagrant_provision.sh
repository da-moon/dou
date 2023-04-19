#!/bin/sh
NODE_VERSION=6

# Set language and locale
apt-get install -y language-pack-en
locale-gen --purge en_US.UTF-8
echo "LC_ALL='en_US.UTF-8'" >> /etc/environment
dpkg-reconfigure locales

# Install basic packages
# inotify is installed because it's a Phoenix dependency
apt-get -qq update
apt-get install -y \
wget \
git \
unzip \
build-essential \
ntp \
inotify-tools \
curl 

# Install local Elixir hex and rebar for the ubuntu user
su - ubuntu -c '/usr/local/bin/mix local.hex --force && /usr/local/bin/mix local.rebar --force'

# Install nodejs and npm
curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
apt-get install -y \
nodejs

export CONSUL_VERSION=1.7.3
curl -sL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip

# Install consul
sudo unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul

# Download consul-template
export CONSUL_TEMPLATE_VERSION=0.24.0
curl -sL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip

# Install consul-template
sudo unzip consul-template.zip
sudo chmod +x consul-template
sudo mv consul-template /usr/bin/consul-template
