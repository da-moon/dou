#!/bin/sh

echo "Running for environment: $ENV_NAME"

BOOTSTRAP_FILE="../../../../environments/bootstrap.tfvars"
INSTALLATION_PREFIX=$(grep "installation_prefix" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
BUCKET=$(grep "bootstrap_bucket_name" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
REGION=$(grep "bootstrap_region" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
if [ "$INSTALLATION_PREFIX" != "" ] ; then KEY=tfstates/$INSTALLATION_PREFIX/tc/${ENV_NAME}/app_core_env ; else KEY=tfstates/tc/${ENV_NAME}/app_core_env ; fi

terraform init -backend-config="bucket=$BUCKET" -backend-config="key=$KEY" -backend-config="region=$REGION"
terraform apply \
    -no-color \
    -var-file=../../../../environments/teamcenter/${ENV_NAME}/env.tfvars \
    -var-file=../../../../environments/teamcenter/common.tfvars \
    -var=env_name=$ENV_NAME \
    -var=artifacts_bucket_name=$BUCKET \
    -var=installation_prefix=$INSTALLATION_PREFIX \
    $DELETE \
    -auto-approve
