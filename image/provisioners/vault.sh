#! /bin/bash
echo "installing vault..."
wget -O /tmp/vault.zip https://releases.hashicorp.com/vault/1.1.1/vault_1.1.1_linux_amd64.zip
unzip /tmp/vault.zip -d /usr/local/bin
