#!/bin/bash -x
# Login as nathan1
client_token=$(curl \
    --request POST \
    --data '{"password": "nathan123"}' \
    http://127.0.0.1:8200/v1/auth/userpass/login/nathan1 | jq -r '.auth.client_token')

export VAULT_TOKEN=$client_token

vault login $client_token

# Create the Azure creds secrets
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data @azure_creds_payload.json \
    http://127.0.0.1:8200/v1/kv/data/azurecreds
