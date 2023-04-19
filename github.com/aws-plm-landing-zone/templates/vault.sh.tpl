#!/bin/bash -x

set -e

export vault_address=${vault_address}

# methods
unseal_vault()
{
  sudo echo 'Preparing to unseal Vault'>> $VAULT_LOG
  sudo echo ${vault_address}>> $VAULT_LOG
  # check vault seal status
  SEALED=$(curl -s "${vault_address}/v1/sys/seal-status" | jq -r '.sealed')
  sudo echo "Is Vault in Sealed State? - $SEALED">> $VAULT_LOG
  while [ $SEALED = "true" ]; do
    # Perform Unseal
    sudo echo 'Unsealing'>> $VAULT_LOG
    SEAL1=$(curl -s -X PUT -d "{\"key\": \"$2\"}" "${vault_address}/v1/sys/unseal")
    SEAL2=$(curl -s -X PUT -d "{\"key\": \"$3\"}" "${vault_address}/v1/sys/unseal")
    SEAL3=$(curl -s -X PUT -d "{\"key\": \"$4\"}" "${vault_address}/v1/sys/unseal")
    sudo echo "Is Vault in Sealed State? - $SEALED">> $VAULT_LOG
    SEALED=$(curl -s "${vault_address}/v1/sys/seal-status" | jq -r '.sealed')
    sleep 5
  done
}

# remove old configuration
rm -r /etc/vault.d/vault.conf.tmp
# Create default configutation
sudo touch /etc/vault.d/vault.conf
sudo touch ~/vault_logs.conf
sudo touch ~/vault_credentials.txt

IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
FILE_FINAL=/etc/vault.d/vault.conf
VAULT_LOG=~/vault_logs.conf
VAULT_CREDS=~/vault_credentials.txt
sudo echo 'Files created'>> $VAULT_LOG

sudo echo 'Init service!!'>> $VAULT_LOG
sudo echo 'storage "consul" {' >> $FILE_FINAL
sudo echo '  address  = "${consul_address}"'>> $FILE_FINAL
sudo echo '  path     = "vault/"' >> $FILE_FINAL
sudo echo '  token    = "${vault_consul_token}"' >> $FILE_FINAL
sudo echo '  redirect_addr = "${vault_address}"' >> $FILE_FINAL
sudo echo '}' >> $FILE_FINAL
sudo echo 'listener "tcp" {' >> $FILE_FINAL
sudo echo '  address     = "0.0.0.0:8200"' >> $FILE_FINAL
sudo echo '  tls_disable = 1' >> $FILE_FINAL
sudo echo '}' >> $FILE_FINAL
sudo echo 'cluster_name = "${cluster_name}"' >> $FILE_FINAL
sudo echo "ui = true" >> $FILE_FINAL
sudo echo "api_addr = \"http://$IP:8200\"" >> $FILE_FINAL

sudo service vault start

# check until service comes up, for 30 seconds
for i in {1..10};
do
  export STATUS=$(sudo systemctl is-active vault)
  if [ $STATUS = 'active' ]; then
    sudo echo 'Vault is ACTIVE!!'>> $VAULT_LOG
    break
  else
    sudo echo 'Vault is not active'>> $VAULT_LOG
    sleep 3
  fi
done

sleep 30s
# check if vault is initialized
sudo echo 'Check if is initialized'>> $VAULT_LOG
sudo echo '${vault_address}'>> $VAULT_LOG
STATUS="begin"
INIT_STATUS=$(/usr/bin/curl "${vault_address}/v1/sys/init" | /usr/bin/jq -r '.initialized')
if [ -z $INIT_STATUS ]; then 
  INIT_STATUS=false
  sudo echo 'Is not initialized'>> $VAULT_LOG
else
  sudo echo 'VAULT Is initialized'>> $VAULT_LOG
fi
echo $INIT_STATUS>> $VAULT_LOG


if [ $INIT_STATUS = "true" ]; then
  sudo echo 'its true'>> $VAULT_LOG
  if ! [ -z $ROOT_TOKEN ]; then
    STATUS="unsealed"
  else
    STATUS="missingtoken"
    sudo echo 'STATUS: missing token'
  fi

elif [ $INIT_STATUS = "false" ]; then
sudo echo 'its false'>> $VAULT_LOG

  # initialize vault
  INIT="{\"secret_shares\": 5, \"secret_threshold\": 3}"
  sudo echo '$INIT'>> $VAULT_LOG
  INITIALIZE=$(curl -s -X PUT -d "$INIT" "${vault_address}/v1/sys/init")
  eval "$(echo $INITIALIZE | jq -r ' "ROOT_TOKEN=\(.root_token) KEY1=\(.keys[0]) KEY2=\(.keys[1]) KEY3=\(.keys[2]) KEY4=\(.keys[3]) KEY5=\(.keys[4])"')"
  sudo echo $INITIALIZE>> $VAULT_LOG
  
  sudo echo $ROOT_TOKEN>> $VAULT_LOG ## root.txt
  unseal_vault ${vault_address} $(echo $INITIALIZE | jq -r '.keys' | jq -r '.[0]') $(echo $INITIALIZE | jq -r '.keys' | jq -r '.[1]') $(echo $INITIALIZE | jq -r '.keys' | jq -r '.[2]')
  
  # s3 
  aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} 
  aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
  aws configure set default.region    ${AWS_REGION}
  sudo echo "root_token: $ROOT_TOKEN" >> $VAULT_CREDS
  sudo echo "key1: $KEY1">> $VAULT_CREDS
  sudo echo "key2: $KEY2">> $VAULT_CREDS
  sudo echo "key3: $KEY3">> $VAULT_CREDS
  sudo echo "key4: $KEY4">> $VAULT_CREDS
  sudo echo "key5: $KEY5">> $VAULT_CREDS
  aws s3 cp ~/vault_credentials.txt "s3://${bucket_name}/"

  STATUS="initialized"
  sudo echo 'STATUS: Initialized'>> $VAULT_LOG
else
  #echo "error reaching vault server"
  STATUS="error"
  sudo echo 'STATUS: error'>> $VAULT_LOG
fi