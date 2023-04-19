#!/bin/sh

VARS_FILE="../../environments/bootstrap.tfvars"
BUCKET=$(grep "bootstrap_bucket_name" $VARS_FILE | awk '{print $3}' | sed -e 's/^"//' -e 's/"$//')
REGION=$(grep "bootstrap_region" $VARS_FILE | awk '{print $3}' | sed -e 's/^"//' -e 's/"$//')
terraform init -backend-config="bucket=$BUCKET" --backend-config="region=$REGION"
if [ "${TERRAFORM_DESTROY}" = "TRUE" ]; then
    terraform destroy \
        -no-color \
        -var-file=${VARS_FILE} \
        -auto-approve
else
    terraform apply \
        -no-color \
        -var-file=${VARS_FILE} \
        -auto-approve
fi

