
SECONDARY_CLUSTER_ID=""
uuid=$(uuidgen)
uuid=${uuid,,}

# TODO if primary mode is activated , do not run this
# 'primary_cluster_addr' This must be empty or else cluster won't get bootstrapped
curl \
  --request POST \
  --header "X-Vault-Token: ${PRIMARY_VAULT_TOKEN}" \
  -d '{"primary_cluster_addr":""}' \
  "${PRIMARY_VAULT_ADDR}/v1/sys/replication/dr/primary/enable"
sleep 3;
# TODO if on secondary, secondary mode is enabled do not run this
CLUSTER_STATUS="$(curl \
  --request GET \
  --header "X-Vault-Token: ${PRIMARY_VAULT_TOKEN}" \
  "${PRIMARY_VAULT_ADDR}/v1/sys/replication/dr/status")"

TO_REVOKE=( $(echo "${CLUSTER_STATUS}" | jq -r '.data.secondaries[] | select(.connection_status == "disconnected").node_id') )
for id in "${TO_REVOKE[@]}"; do
  curl -s \
  --request POST \
  --header "X-Vault-Token: ${PRIMARY_VAULT_TOKEN}" \
  -d "{\"id\": \"$id\"}" \
  "${PRIMARY_VAULT_ADDR}/v1/sys/replication/dr/primary/revoke-secondary"
done
sleep 3;

JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN="$(curl \
  --request POST \
  --header "X-Vault-Token: ${PRIMARY_VAULT_TOKEN}" \
  --data "{ \"id\": \"${uuid}\",\"ttl\": \"30m\" }" \
  "${PRIMARY_VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
sleep 3;

curl \
  --request POST \
  --header "X-Vault-Token: ${SECONDARY_VAULT_TOKEN}" \
  -d "{ \"token\": \"${JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN}\" }" \
  $SECONDARY_VAULT_ADDR/v1/sys/replication/dr/secondary/enable | jq -r
