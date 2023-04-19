#!/bin/bash

echo "##[group]Debugging terraform13 plan"

echo "##[command]terraform13 init -input=false"
terraform13 init -input=false -no-color

# Code validation
if [ "$SKIP_TF_VALIDATE" = "False" ]; then
    echo "##[command]terraform13 validate"
    terraform13 validate -no-color
else
    echo "##[debug]Skipping terraform13 validate as SKIP_TF_VALIDATE is $SKIP_TF_VALIDATE"
fi

# Configuring Autovars
# if [[ -f "tfvars/$ENV_NAME.tfvars" ]]; then
# 	echo "##[debug]Configuring Autovars"
#     rm -rf tfvars/*.auto.tfvars
#     rm -rf *.auto.tfvars
#     cp tfvars/$TFE_WORKSPACE.tfvars $TFE_WORKSPACE.auto.tfvars
# fi

# echo -e "vault_token = \"`vault login -token-only -tls-skip-verify -address="https://vault-cldsvc-prod.corp.internal.citizensbank.com/" -method=aws role=jenkins-aws-role`\"" > token.auto.tfvars

echo "##[command]terraform13 plan"
#terraform13 plan -var-file=$ENV_NAME.auto.tfvars -no-color
terraform13 plan -no-color

status=$?
if [ $status -eq 1 ]; then
   echo "##[error]*****terraform13 planning issues found, fix your issues to proceed.*****"
fi

exit $status
