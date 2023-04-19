#!/bin/bash +x

function create_backend(){
  echo "##[debug] Creating tfautovars"
  echo -e "vault_token = \"`vault login -token-only -tls-skip-verify -address="https://vault-cldsvc-prod.corp.internal.citizensbank.com/" -method=aws role=jenkins-aws-role`\"" > token.auto.tfvars

  echo "##[debug] Creating override.tf for backend configuration"
  cat <<EOF > override.tf
terraform {
  backend "remote" {
    hostname     = "$TFE_HOST"
    organization = "$TFE_ORG"

    workspaces {
      name = "$TFE_WORKSPACE"
    }
  }
}
EOF

  echo "##[command] cat override.tf"
  cat override.tf
  echo "##[debug] Finishing to create override.tf for backend configuration"
}

create_backend