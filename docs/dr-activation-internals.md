# dr-activation-internals

- [dr-activation-internals](#dr-activation-internals)
  - [Overview](#overview)
  - [Process](#process)
    - [Enable DR Replication](#enable-dr-replication)
    - [Response-Wrapped Secondary Activation Token](#response-wrapped-secondary-activation-token)
    - [Encrypted Secondary Activation Token](#encrypted-secondary-activation-token)
    - [Join Secondary node](#join-secondary-node)
  - [Debugging](#debugging)
    - [Response Wrapped Activation Token](#response-wrapped-activation-token)
    - [Certificates](#certificates)
  -
## Overview

This document walks through the process of DR activation while demonstrating
what API calls Vault makes under the hood.
Broadly speaking, The following are steps involved in DR activation:

- Tell a node in a vault cluster that it is the Primary cluster (Activate DR Replication)
- Ask The node in Primary cluster to generate a Secondary activation token
- Give secondary activation token to a node in another vault cluster (Secondary cluster)

By default, This secondary activation token is quite special and different from your regular
Vault tokens; It is in fact a `JWT` token: e.g:

```json
{
  "accessor": "",
  "addr": "http://vault-dc1-leader:8200",
  "exp": 1666197768,
  "iat": 1666195968,
  "jti": "hvs.Cfu9F7ueHxJ3nqXIuvGyL3zO",
  "nbf": 1666195963,
  "type": "wrapping"
}
```

Then , Vault server on secondary sends an API call to primary, using the address
in `addr` fields and sets `X-Vault-Token` header to the value of `jti` field ;
This is how they establish connection.

The `jti` field is a response-wrapped token; the following is an example
unwrapped vaules inside the token

```json
{
  "ca_cert": "MIICfTCCAd+gAwIBAgIIay0czGJlvoswCgYIKoZIzj0EAwQwMzExMC8GA1UEAxMocmVwLTYyY2FmNDA4LWI1YWUtOTI1Ni1mZWE0LWE4MjkzOGIxMjA0YzAgFw0yMjEwMTkxNTU5NDRaGA8yMDUyMTAxOTA0MDAxNFowMzExMC8GA1UEAxMocmVwLTYyY2FmNDA4LWI1YWUtOTI1Ni1mZWE0LWE4MjkzOGIxMjA0YzCBmzAQBgcqhkjOPQIBBgUrgQQAIwOBhgAEAL0itjyVm0ObXQxb815wSvzb8/F8UbC1ZV0/eGkZt1D+LGuRVZHqcjRSt189zqtGWwTFdzUlpB46fYHFJKWKmrsOAEX/u+57PxyoJ7ad5eosS2Q0zZdZx8eg1EzG0TXEHPM1qQCuU1rpD5ygXKWlMZI5rpai1qtXvH5vQs/FL+nsa2vko4GXMIGUMA4GA1UdDwEB/wQEAwICrDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUrztAiypcw4JAnfOGMVaotDn/YL0wMwYDVR0RBCwwKoIocmVwLTYyY2FmNDA4LWI1YWUtOTI1Ni1mZWE0LWE4MjkzOGIxMjA0YzAKBggqhkjOPQQDBAOBiwAwgYcCQR9fX3eRPOCrq9JHpVDo4au3Ji7b4mQr87//lZvd/n8k7iHKT1atM00B3ICDWXkSULzuNq0p8+x7d/XX20HlXgNMAkIB+U7V/1M/kwa79RIKV+Lmzl6JNvT1ZIiGLVIneNxehcJBs10A1yPuz6DBrPPtcHRQJ0yQDYEuoUGiN/aO7vvENnU=",
  "client_cert": "MIICZjCCAcigAwIBAgIIJvFPGIUtic4wCgYIKoZIzj0EAwQwMzExMC8GA1UEAxMocmVwLTYyY2FmNDA4LWI1YWUtOTI1Ni1mZWE0LWE4MjkzOGIxMjA0YzAgFw0yMjEwMTkxNjEyMTdaGA8yMDUyMTAxOTA0MTI0N1owLzEtMCsGA1UEAxMkNGY2YmRmZTMtYjg1ZS0yN2M3LTMyMzgtMjU0NDRhY2FhODdiMIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQAsLERngbl+v2bHk+kv9Tmlo3LxqoWXdDbBSaBqOOm/654C/4TSuqrqvQzN/qZvA9Cz4migIGiPuTtyht6oPc2avIAAzyyhwcJ4h0Ird1vWbtxUCkzinBQRM7uMfLRGjRg4jgGN2zAbcfL8QZrsT8O6a54DDKdqf7qrj+P+YhDUMWMEo+jgYQwgYEwDgYDVR0PAQH/BAQDAgOoMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAfBgNVHSMEGDAWgBSvO0CLKlzDgkCd84YxVqi0Of9gvTAvBgNVHREEKDAmgiQ0ZjZiZGZlMy1iODVlLTI3YzctMzIzOC0yNTQ0NGFjYWE4N2IwCgYIKoZIzj0EAwQDgYsAMIGHAkIBcxUFn8VOwvFQmyVs06pkYwI4+rXqCGm6WaCse/GKgEPA/RQCWE+u+FkUiHMcmWNC8GamekarMasXTaRtwR1TUZMCQVhSADbR8/+R3meKhb7mTNyxyhNVJAXqT3fP2TtAsr0tHjfdCCkSu9fMcwwftiA9xeyvWD7SHi6F96G//c9vX28a",
  "client_key": {
    "type": "p521",
    "x": 2.369048042139e+156,
    "y": 4.340240315352359e+154,
    "d": 6.74715658972406e+156
  },
  "cluster_id": "1e627067-a543-97cb-2ae8-2a26024948f2",
  "encrypted_client_key": null,
  "id": "secondary-dc",
  "mode": 512,
  "nonce": null,
  "primary_cluster_addr": "https://vault-dc1-leader:8201",
  "primary_public_key": null
}
```

This is how they exchange initial information , assuming you use
response-wrapped token approach.

Alternatively, you can ask the Secondary to give expose it's CA information and
pass it to primary cluster.


## Process

### Enable DR Replication

- [Enable Disaster Recovery on the primary cluster][enable-disaster-recovery-on-the-primary-cluster]

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/enable" | jq
```

In case you are using TLS, use the following

```bash
curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/enable" ;
```

### Response-Wrapped Secondary Activation Token

- Generate a DR secondary activation token for the cluster. In the payload of
  this request, you need to include a unique, opaque identifier for the
  secondary cluster (e.g cluster name).

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
SECONDARY_ACTIVATION_TOKEN="$(curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data '{ "id": "secondary-dc","ttl": "30m" }' \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
echo ${SECONDARY_ACTIVATION_TOKEN}
```

In case you are using TLS, use the following :

```bash
SECONDARY_ACTIVATION_TOKEN="$(curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data '{ "id": "secondary-dc","ttl": "30m" }' \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
echo ${SECONDARY_ACTIVATION_TOKEN}
```

### Encrypted Secondary Activation Token

- [Fetch DR Secondary Public Key][fetch-dr-secondary-public-key]; which is the public key that is used to encrypt the returned credential information.

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Secondary cluster
SECONDARY_PUBLIC_KEY="$(curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/secondary/generate-public-key" \
| jq -r '.data.secondary_public_key' )" ;
echo ${SECONDARY_PUBLIC_KEY}
```

In case you are using TLS, use the following :

```bash
SECONDARY_PUBLIC_KEY="$(curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/secondary/generate-public-key" \
| jq -r '.data.secondary_public_key' )" ;
echo ${SECONDARY_PUBLIC_KEY}
```

- Generate a DR secondary activation token for the cluster. In the payload of
  this request, you need to include a unique, opaque identifier for the
  secondary cluster (e.g cluster name). You should include secondary cluster
  public key in this payload

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
SECONDARY_ACTIVATION_TOKEN="$(curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data "{ \"id\": \"secondary-dc\",\"ttl\": \"30m\",\"secondary_public_key\" : \"${SECONDARY_PUBLIC_KEY}\" }" \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.data.token' )" ;
echo ${SECONDARY_ACTIVATION_TOKEN}
```

In case you are using TLS, use the following :

```bash
SECONDARY_ACTIVATION_TOKEN="$(curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data '{ "id": "secondary-dc","ttl": "30m" }' \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
echo ${SECONDARY_ACTIVATION_TOKEN}
```

### Join Secondary node

- Activate secondary, either using response-wrapped token or with the encrypted token

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Secondary cluster
curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  -d "{ \"token\": \"${SECONDARY_ACTIVATION_TOKEN}\" }" \
  $VAULT_ADDR/v1/sys/replication/dr/secondary/enable | jq -r
```

In case you are using TLS, use the following :

```bash
curl -s \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  -d "{ \"token\": \"${SECONDARY_ACTIVATION_TOKEN}\" }" \
  $VAULT_ADDR/v1/sys/replication/dr/secondary/enable | jq -r
```

## Debugging

### Response Wrapped Activation Token

In case there are issues with the JWT token primary gave you, we would need to
dissect it.

- [Get cluster status][get-cluster-status] on primary Vault DC

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
CLUSTER_STATUS="$(curl -s \
  --request GET \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/status")"
echo "${CLUSTER_STATUS}" | jq
```

In case you are using TLS, use the following

```bash
CLUSTER_STATUS="$(curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request GET \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/status")"
echo "${CLUSTER_STATUS}" | jq
```


- [Revoke unused secondary tokens][revoke-unused-secondary-tokens].

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
TO_REVOKE=( $(echo "${CLUSTER_STATUS}" | jq -r '.data.secondaries[] | select(.connection_status == "disconnected").node_id') )
for id in "${TO_REVOKE[@]}"; do
  curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  -d "{\"id\": \"$id\"}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/revoke-secondary"
done
```

In case you are using TLS, use the following :

```bash
echo "${CLUSTER_STATUS}" | jq -r '.data.secondaries[] | select(.connection_status == "disconnected").node_id'
TO_REVOKE=( $(echo "${CLUSTER_STATUS}" | jq -r '.data.secondaries[] | select(.connection_status == "disconnected").node_id') )
for id in "${TO_REVOKE[@]}"; do
  curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  -d "{\"id\": \"$id\"}" \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/revoke-secondary"
done
```

- Now, we generate another Encoded JWT Token

```bash
# VAULT_TOKEN and VAULT_ADDR are targeting Primary cluster
JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN="$(curl -s \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data '{ "id": "secondary-dc-debug","ttl": "30m" }' \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
echo ${JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN}
```

In case you are using TLS, use the following :

```bash
JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN="$(curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
  --request POST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --data '{ "id": "secondary-dc-debug","ttl": "30m" }' \
  "${VAULT_ADDR}/v1/sys/replication/dr/primary/secondary-token" \
| jq -r '.wrap_info.token' )" ;
echo ${JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN}
```

- Now , we need to decode the JWT Token

```bash
sanitized=$(echo ${JWT_ENCODED_SECONDARY_ACTIVATION_TOKEN} \
| cut -d "." -f 2)
len=$((${#sanitized} % 4))
if [ $len -eq 2 ]; then sanitized="$1"'=='; elif [ $len -eq 3 ]; then sanitized="$1"'=' ; fi
DECODED_JWT_PRIMARY_ACTIVATION_TOKEN=$(echo "$sanitized" \
| tr '_-' '/+' \
| openssl enc -d -base64)
echo "${DECODED_JWT_PRIMARY_ACTIVATION_TOKEN}" | jq
```

In this payload, `addr` field and `jti` are of importance. Vault server on the secondary takes in the response wrapped token in `jti` field and sends an API
call to the Vault server in `addr` field; Asking the server to unwrap it.
Essentially, The api call Vault server on secondary makes to the primary is the
following

```bash
TARGET="$(echo "${DECODED_JWT_PRIMARY_ACTIVATION_TOKEN}" | jq -r '.addr')"
TOKEN="$(echo "${DECODED_JWT_PRIMARY_ACTIVATION_TOKEN}" | jq -r '.jti')"
curl -s \
  --request PUT \
  --header "X-Vault-Token: ${TOKEN}" \
  "${TARGET}/v1/sys/wrapping/unwrap" \
| jq
```

So to debug properly, see if the above command would have a response when it is
called from Secondary node.

### Certificates

- See if you can send an API call to health-check endpoint

```bash
curl \
  --cacert "${VAULT_CAPATH}" \
  --cert "${VAULT_CLIENT_CERT}" \
  --key "${VAULT_CLIENT_KEY}" \
https://${TARGET_VAULT_ADDR}/v1/sys/health -I
```


The following snippets can be used for analyze self-signed certificate of a
vault node

- Grab remote bundle

```bash
openssl s_client \
  -servername ${TARGET_VAULT_ADDR}
  -connect ${TARGET_VAULT_ADDR}:443 \
    </dev/null 2>/dev/null \
| openssl x509 -text
```

- Extract certificate

```bash
echo | openssl s_client \
  -connect ${TARGET_VAULT_ADDR}:443 2>&1 \
| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem
```

- Extract in `DER` format if needed

```bash
openssl s_client \
  -showcerts \
  -connect ${TARGET_VAULT_ADDR}:443 < /dev/null \
| openssl x509 -outform DER > cert.der
```


[enable-disaster-recovery-on-the-primary-cluster]: https://developer.hashicorp.com/vault/api-docs/system/replication/replication-dr#enable-dr-primary-replication
[get-cluster-status]: https://developer.hashicorp.com/vault/api-docs/system/replication/replication-dr#check-dr-status
[revoke-unused-secondary-tokens]: https://developer.hashicorp.com/vault/api-docs/system/replication/replication-dr#revoke-dr-secondary-token
[fetch-dr-secondary-public-key]:https://developer.hashicorp.com/vault/api-docs/system/replication/replication-dr#fetch-dr-secondary-public-key
