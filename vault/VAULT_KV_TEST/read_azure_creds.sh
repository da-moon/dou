#!/bin/bash -x
# Login as stuart1
client_token=$(curl \
    --request POST \
    --data '{"password": "stuart456"}' \
    http://127.0.0.1:8200/v1/auth/userpass/login/stuart1 | jq -r '.auth.client_token')

export VAULT_TOKEN=$client_token

# Read the Azure creds secrets
hostnames=$(curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    http://127.0.0.1:8200/v1/kv/data/azurecreds | jq -r '.data.data.hostnames')

export HOSTNAMES=$hostnames

password=$(curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    http://127.0.0.1:8200/v1/kv/data/azurecreds | jq -r '.data.data.password')

export PASSWORD=$password

azure_subscription_id=$(curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    http://127.0.0.1:8200/v1/kv/data/azurecreds | jq -r '.data.data.azure_subscription_id')

export AZURE_SUBSCRIPTION_ID=$azure_subscription_id

echo "HOSTNAMES=$HOSTNAMES"
echo "PASSWORD=$PASSWORD"
echo "AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID"
