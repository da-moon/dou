#! /bin/bash
echo "Installing terraform..."
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
unzip /tmp/terraform.zip -d /usr/local/bin/
