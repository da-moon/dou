#!/bin/bash

set -e

cd ./spw

TFE_HOST="terraform-cldsvc-prod.corp.internal.citizensbank.com"
TFE_ORG="cfg-cloud-services"

function create_provider(){
  echo "##[debug] Creating override.tf for backend configuration"
  cat <<EOF > provider.tf
provider "vault" {
  address         = "https://vault-cldsvc-prod.corp.internal.citizensbank.com/"
  skip_tls_verify = true
  token = var.vault_token
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = var.vault_role_name
  type    = "sts"
}

provider "aws" {
  version = "~> 3.0"
  region  = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token      = data.vault_aws_access_credentials.creds.security_token
}
EOF

  echo "##[command] cat provider.tf"
  cat provider.tf
  echo "##[debug] Finishing to create provider.tf for backend configuration"
}

create_provider


function create_backend(){
  echo "##[debug] Creating override.tf for backend configuration"
  cat <<EOF > backend.tf
terraform {
  backend "remote" {
    hostname     = "${TFE_HOST:-terraform-cldsvc-prod.corp.internal.citizensbank.com}"
    organization = "${TFE_ORG:-cfg-cloud-services}"

    workspaces {
      name = "${APP_NAME}-app-${TFE_WORKSPACE}"
    }
  }
}
EOF

  echo "##[command] cat backend.tf"
  cat backend.tf
  echo "##[debug] Finishing to create backend.tf for backend configuration"
}

create_backend

function create_vault_variables(){
  echo "##[debug] Creating vault_variables.tf for backend configuration"
  cat <<EOF > vault_variables.tf
variable "vault_token" {
 description = "vault token created during automation - do not supply"
 type        = string
 default     = null
}

variable "vault_role_name" {
 description = "vault role name"
 type        = string
 default     = null
}
EOF
  echo "##[command] cat vault_variables.tf"
  cat vault_variables.tf
  echo "##[debug] Finishing to create vault_variables.tf for backend configuration"
}

create_vault_variables
