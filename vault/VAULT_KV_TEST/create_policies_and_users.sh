#!/bin/sh -x

#Enable kv secrets engine
vault secrets enable -path=kv -version=2 kv

# Enable the userpass auth method
vault auth enable userpass

# create the policies
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data @azurecred_secrets_owner.json \
    http://127.0.0.1:8200/v1/sys/policy/azurecred_secrets_owner

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data @azurecred_secrets_consumer.json \
    http://127.0.0.1:8200/v1/sys/policy/azurecred_secrets_consumer

# create the nathan1 user
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data @nathan_payload.json \
    http://127.0.0.1:8200/v1/auth/userpass/users/nathan1

# create the stuart1 user
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data @stuart_payload.json \
    http://127.0.0.1:8200/v1/auth/userpass/users/stuart1
