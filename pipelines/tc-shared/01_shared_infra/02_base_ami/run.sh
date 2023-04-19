#!/bin/sh

BOOTSTRAP_FILE="../../../../environments/bootstrap.tfvars"
INSTALLATION_PREFIX=$(grep "installation_prefix" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
BUCKET=$(grep "bootstrap_bucket_name" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
REGION=$(grep "bootstrap_region" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
TEAMCENTER_BUCKET=$(grep "teamcenter_s3_bucket_name" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
if [ "$INSTALLATION_PREFIX" != "" ] ; then KEY=tfstates/$INSTALLATION_PREFIX/tc/base_ami ; else KEY=tfstates/tc/base_ami ; fi
terraform init -backend-config="bucket=$BUCKET" -backend-config="key=$KEY" -backend-config="region=$REGION" --reconfigure
terraform apply \
    -no-color \
    -var-file=../../../../environments/teamcenter/common.tfvars \
    -var=artifacts_bucket_name=$BUCKET \
    -var="region=$REGION" \
    $REBAKE \
    -auto-approve
