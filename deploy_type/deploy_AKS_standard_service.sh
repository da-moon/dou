#!/bin/sh
ROOT=`pwd`
DEPLOY="${ROOT}/terraform_deploy"
#----------------
# Login to azure
#----------------
echo -e "Service Principal credentials detected; logging in with Service Principal\n"
az login \
  --service-principal \
  --tenant $ARM_TENANT_ID \
  -u $ARM_CLIENT_ID \
  -p $ARM_CLIENT_SECRET

#--------------
# Set Licenses
#--------------
# cat << EOF > license_consul.txt
#     $LICENSE_CONSUL
# EOF
#
# cat << EOF > license_vault.json
# {
#     "text": "$LICENSE_VAULT"
# }
# EOF

#------------------
# Setup for VAULT
#------------------

# For Vault Initialization
# cat << EOF > init.json
# {
#   "recovery_shares": 5,
#   "recovery_threshold": 3
# }
# EOF

# Data stored in Vault. Needed to run CaaS container
# cat << EOF > caas_vault_data.json
# {
#     "DJANGO_SECRET_KEY" : "changeme",
#     "POSTGRESQL_PASS" : "$POSTGRES_PASS",
#     "RABBITMQ_PASSWORD" : "rabbit"
# }
# EOF

# For enabling KV version 1.
# cat << EOF > kv_secret.json
# {
#   "type": "kv",
#   "description": "First Secret Enabled Manually",
#   "config": {
#     "force_no_cache": true,
#     "default_lease_ttl": "30m",
#     "max_lease_ttl": "30m"
#   },
#   "options": {
#       "version": "1"
#   }
# }
# EOF

#---------------
# Where am I?
#---------------
pwd
ls -la
env

#----------------
# Setting ALL UP
#----------------

# echo -e "\n\t-Starting point-\n"
#
# # Initialize vault and store keys
# curl \
#   --request PUT \
#   --data @init.json \
#   http://$DNS_VAULT:8200/v1/sys/init -o vault_creds.txt
#
# # Display vault_creds.txt content
# echo -e "\n\t-Vault Credentials-\n"
# cat vault_creds.txt

# Set vault root token
# export VAULT_TOKEN=$(cat vault_creds.txt | jq -r '.root_token')
#
# echo -e "\n\tVault Initialized, VAULT_TOKEN:$VAULT_TOKEN"
# echo -e "\n\tCONSUL_HTTP_TOKEN:$CONSUL_HTTP_TOKEN\n"

#-----------------
# Adding Licenses
#-----------------

# Consul
# consul_license_status=$(curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data @license_consul.txt \
#     http://$DNS_CONSUL:8500/v1/operator/license)
#
# if [[ consul_license_status == *"license_id"* ]]; then
#     echo -e "\n\t-License for consul ADDED-"
# else
#     echo -e "\n\t-License for consul was NOT ADDED-\n"
# fi
#
#
# # Vault
# vault_license_status=curl \
#     --header "X-Vault-Token: $VAULT_TOKEN" \
#     --request PUT \
#     --data @license_vault.json \
#     http://$DNS_VAULT:8200/v1/sys/license
#
# if [[ vault_license_status == *"license_id"* ]]; then
#     echo -e "\n\t-License for vault ADDED-"
# else
#     echo -e "\n\t-License for vault was NOT ADDED-\n"
# fi


#----------------
# Setting VAULT
#----------------
# # Enable at path=secret/ secret engine-> kv1
# request=$(curl \
#     --header "X-Vault-Token: $VAULT_TOKEN" \
#     --request POST \
#     --data @kv_secret.json \
#     http://$DNS_VAULT:8200/v1/sys/mounts/secret)
#
#
# if [[ request == *"error"* ]]; then
#     echo -e "\n\t-vault kv v1 NOT ENABLED path:secret/ -\n"
# else
#     echo -e "\n\t-vault kv v1 ENABLED path:secret/ -\n"
# fi
#
# # Put kv secrets into vault
# curl \
#     --header "X-Vault-Token: $VAULT_TOKEN" \
#     --request POST \
#     --data @caas_vault_data.json \
#     http://$DNS_VAULT:8200/v1/secret/django_secrets
#
# echo -e "\nVault secrets written at secret/django_secrets \n"
#

#----------------
# Setting CONSUL
#----------------
# Consul kv for Postgres
# consul kv put POSTGRESQL_HOST $DB_host
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_host \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRESQL_HOST
#
# # consul kv put POSTGRES_USER $DB_user
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_user \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRES_USER
#
# # consul kv put POSTGRES_DB $DB_dbname
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_dbname \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRES_DB
#
# # consul kv put POSTGRESQL_PORT $DB_port
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_port \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRESQL_PORT
#
# # consul kv put POSTGRESQL_NAME $DB_labelname
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_labelname \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRESQL_NAME
#
# # SSL
# curl \
#     --header "X-Consul-Token: $CONSUL_HTTP_TOKEN" \
#     --request PUT \
#     --data $DB_sslmode \
#     http://$DNS_CONSUL:8500/v1/kv/POSTGRESQL_SSL
#
# echo -e "\nConsul kv already written\n"

#----------
# CAAS API
#----------
# RUN container
AZ_TOKEN=$(az acr login -n $ACR_NAME --expose-token | jq -r '.accessToken')
AZ_REGISTRY=$(az acr login -n $ACR_NAME --expose-token | jq -r '.loginServer')

echo -e "\nAZ_REGISTRY : $AZ_REGISTRY\n"

# az container create -g valkyrie-test --name mycontainer --dns-name-label caasapiluis \
#     --image $AZ_REGISTRY/thisisatest:latest --ports 80 8000  \
#     --registry-username $AZURE_SP \
#     --registry-password $AZURE_SP_PASSWORD \
#     -e VAULT_TOKEN=$VAULT_TOKEN \
#     CONSUL_TOKEN=$CONSUL_HTTP_TOKEN \
#     KEYS_DIR=django_secrets \
#     VAULT_DEV_LISTEN_ADDRESS=$DNS_VAULT \
#     CONSUL_DEV_LISTEN_ADDRESS=$DNS_CONSUL

# az container show -g valkyrie-test --name mycontainer --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

# az container list -g valkyrie-test --output table

# Clean
# az container delete -g valkyrie-test --name mycontainer

# az acr login --name $ACR_NAME

# echo -e "\nLogged to ACR\n"

#-------------
# AKS Cluster
#-------------
# az aks install-cli
#
# echo -e "\nAKS installed\n"
#
# az aks get-credentials --resource-group valkyrie-test --name caasapi-example-aks1
# echo -e "\nAKS Logged\n"
#
# kubectl get nodes
#
# sed s/%VAULT_TOKEN%/$VAULT_TOKEN/g aks_caas.yml.tpl > aks_caas.yml
# sed -i s/%CONSUL_TOKEN%/$CONSUL_HTTP_TOKEN/g aks_caas.yml
# sed -i s/%VAULT_DEV_LISTEN_ADDRESS%/$DNS_VAULT/g aks_caas.yml
# sed  -i s/%CONSUL_DEV_LISTEN_ADDRESS%/$DNS_CONSUL/g aks_caas.yml
#
# ls -la
#
# echo -e "\nyaml file edited\n"
# cat aks_caas.yml
# pwd


echo "mkdir ${DEPLOY}"
mkdir ${DEPLOY}

# Copy in service to deploy
echo "cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}"
cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}

#Copy modules too
echo "cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}"
cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}

echo "moving local.tf file"
echo "cp local.tf ${DEPLOY}"
cp local.tf ${DEPLOY}

if [ ${CIRCLE_BRANCH} = "develop" ]; then
  TERRAFORM_ENV=dev
elif [ ${CIRCLE_BRANCH} = "master" ]; then
  TERRAFORM_ENV=prod
else
  TERRAFORM_ENV=jason  #${CIRCLE_BRANCH}
fi

echo "Lets see what is in the local and in deploy\n"
ls -la
pwd
echo "local\n"
ls -la ${DEPLOY}



echo "Install Terraform for now \n"
echo "Where are we? "
pwd
ls -la
echo "curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip"
curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin
echo $PATH


echo "Move to terraform_deploy directory"
cd ${DEPLOY}
echo "Show all my files"
ls -la

echo "set my .terraformrc file"
mkdir ~/.terraform.d
touch ~/.terraform.d/credentials.tfrc.json
echo "{ \"credentials\": { \"app.terraform.io\": { \"token\": \"${TERRAFORM_CLOUD_API_TOKEN}\" } } }" >> ~/.terraform.d/credentials.tfrc.json

cat ~/.terraform.d/credentials.tfrc.json

echo "Init workspace first"
terraform init

workspace=''
echo "Select terraform workspace"
workspace='true'
echo "trying to select workspace with terraform workspace select $TERRAFORM_ENV"
terraform workspace select $TERRAFORM_ENV
if [ $? -ne 0 ]; then
   echo "$TERRAFORM_ENV workspace not available, create one"
   terraform workspace new $TERRAFORM_ENV
   terraform init
   if [ $? -ne 0 ]; then
      echo "Error selecting workspace terraform."
      workspace='false'
      exit 1
   fi
fi


terraform init

echo "Create deployment.auto.tfvars"
touch deployment.auto.tfvars
echo "touch deployment.auto.tfvars"
ls -la
pwd

aks_regex="aks*"
ecs_regex="ecs*"
eks_regex="eks*"

if [[ ${SUPPORTED_PRODUCT_WORKLOAD} = $aks_regex ]]; then
  PLATFORM="azure"
elif [[ ${SUPPORTED_PRODUCT_WORKLOAD} = $eks_regex ]]; then
  PLATFORM="aws"
elif [[ ${SUPPORTED_PRODUCT_WORKLOAD} = $ecs_regex ]]; then
  PLATFORM="aws"
fi

if [ ${PLATFORM} = "develop" ]; then
  printf "container_version = \"${codeHash}\"\n" >> deployment.auto.tfvars

  printf "container_image   = \"${AWS_ECR_REPO_URL}\"\n" >> deployment.auto.tfvars

  printf "run_env           = \"${TERRAFORM_ENV}\"\n" >> deployment.auto.tfvars

  printf "project           = \"${TERRAFORM_PROJECT}\"\n" >> deployment.auto.tfvars

  printf "aws_region        = \"${AWS_DEFAULT_REGION}\"\n" >> deployment.auto.tfvars

  printf "landing_zone      = \"${LANDING_ZONE}\"\n" >> deployment.auto.tfvars

elif [ ${PLATFORM} = "azure" ]; then
  # printf "container_version = \"${codeHash}\"\n" >> deployment.auto.tfvars
  #
  # printf "container_image   = \"${AWS_ECR_REPO_URL}\"\n" >> deployment.auto.tfvars
  #
  # printf "run_env           = \"${TERRAFORM_ENV}\"\n" >> deployment.auto.tfvars
  #
  # printf "project           = \"${TERRAFORM_PROJECT}\"\n" >> deployment.auto.tfvars
  #
  # printf "location        = \"${AZURE_LOCATION}\"\n" >> deployment.auto.tfvars

  printf "landing_zone      = \"${LANDING_ZONE}\"\n" >> deployment.auto.tfvars

fi

echo "You will be deploying your task with these variables : \n"
cat deployment.auto.tfvars
printf "AND \n"
echo "$(cat deployment.auto.tfvars)"


echo "Terraform apply"
if [ ${TERRAFORM_DESTROY} = "TRUE" ]; then
    terraform destroy -auto-approve -lock=true
else
    terraform apply -auto-approve -lock=true
fi
