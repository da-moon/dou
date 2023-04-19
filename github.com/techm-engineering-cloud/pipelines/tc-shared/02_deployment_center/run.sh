#!/bin/sh

BOOTSTRAP_FILE="../../../environments/bootstrap.tfvars"
INSTALLATION_PREFIX=$(grep "installation_prefix" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
BUCKET=$(grep "bootstrap_bucket_name" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
REGION=$(grep "bootstrap_region" "${BOOTSTRAP_FILE}" | awk '{print $3}' | sed 's|"||g')
if [ "$INSTALLATION_PREFIX" != "" ] ; then KEY=tfstates/$INSTALLATION_PREFIX/tc/dc ; else KEY=tfstates/tc/dc ; fi
if [ "$FORCE_REBAKE" != "" ] ; then REBAKE=-var="force_rebake=$FORCE_REBAKE" ; fi
if [ "$DELETE_DATA" != "" ] ; then DELETE=-var="delete_data=$DELETE_DATA" ; fi

terraform init -backend-config="bucket=$BUCKET" -backend-config="key=$KEY" -backend-config="region=$REGION" -migrate-state
terraform apply \
  -no-color \
  -var-file=../../../environments/teamcenter/common.tfvars \
  -var="artifacts_bucket_name=$BUCKET" \
  -var="installation_prefix=$INSTALLATION_PREFIX" \
  $REBAKE \
  $DELETE \
  -auto-approve
