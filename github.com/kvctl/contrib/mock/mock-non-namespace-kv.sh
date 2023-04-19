#!/usr/bin/env bash
set -o errtrace
set -o functrace
set -o errexit
set -o nounset
set -o pipefail

### create engines
## declare an array variable
declare -a arr=("element2" "element3" "element21")
declare -a arr2=("godzilla.ci" "godzilla.dev/one/" "godzilla.dev/two/" "secret3" "secret11/one/two" "secret31/one/two/three" "secret22/one/two/three/four.0" "secret22/one/two/three/four.1" "secret22/one/two/three/four.2" "secret22/one/two/three/four.3" "secret22/one/two/three.0" "secret22/one/two/three.1" "secret22/one/two/three.2" "secret22/one/two/three.3" "secret32")

for i in "${arr[@]}"
do
   echo "$i"
   vault secrets disable "$i"
   vault secrets enable -path="$i" -version=2 kv
done


### fill engines with mock data
for i in "${arr[@]}"
do
   echo "$i"
   for secret in "${arr2[@]}"
   do
    echo "$secret"
    vault kv put "$i/$secret" "$(echo $RANDOM | md5sum | head -c 20; echo;)=$(echo $RANDOM | md5sum | head -c 20; echo;)"
   done
done

declare -a arr=("element5" "element4" "element67")

### Make some KV1 engines too
for i in "${arr[@]}"
do
   echo "$i"
   vault secrets disable "$i"
   vault secrets enable -path="$i" kv
done
for i in "${arr[@]}"
do
   echo "$i"
   for secret in "${arr2[@]}"
   do
    echo "$secret"
    vault kv put "$i/$secret" "$(echo $RANDOM | md5sum | head -c 20; echo;)=$(echo $RANDOM | md5sum | head -c 20; echo;)"
   done
done

policy=$(cat <<EOF
# Full capabilities on the secret engines but nothing on the sys/ endpoints
path "element2/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element3/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element21/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element4/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element5/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element67/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv2/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
)

echo "${policy}" | vault policy write kv-admin -

# Namespace code
#for i in "${arr[@]}"
#do
#   echo "$i"
#   vault namespace create "ns_$i"
#done
#
#vault namespace create "godzilla"
