#!/bin/sh

BOOTSTRAP_FILE="../../../../environments/bootstrap.tfvars"
INSTALLATION_PREFIX=$(grep "installation_prefix" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
BUCKET=$(grep "bootstrap_bucket_name" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
REGION=$(grep "bootstrap_region" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
if [ "$INSTALLATION_PREFIX" != "" ] ; then KEY=tfstates/$INSTALLATION_PREFIX/tc/${ENV_NAME}/deploy_aw_gateway ; else KEY=tfstates/tc/${ENV_NAME}/deploy_aw_gateway ; fi
terraform init -backend-config="bucket=$BUCKET" -backend-config="key=$KEY" -backend-config="region=$REGION"

if [ "${TERRAFORM_DESTROY}" = "TRUE" ]; then
    terraform destroy \
    -no-color \
    -var-file=../../../../environments/teamcenter/common.tfvars \
    -var-file=../../../../environments/teamcenter/${ENV_NAME}/env.tfvars \
    -var="artifacts_bucket_name=$BUCKET" \
    -var=env_name=$ENV_NAME \
    -auto-approve
else
    terraform apply \
    -no-color \
    -var-file=../../../../environments/teamcenter/common.tfvars \
    -var-file=../../../../environments/teamcenter/${ENV_NAME}/env.tfvars \
    -var="artifacts_bucket_name=$BUCKET" \
    -var=env_name=$ENV_NAME \
    -auto-approve
fi
