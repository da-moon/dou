#!/bin/bash

cd ./spw

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

# Workspace creation
# echo "##[debug]TF_WORKSPACE = $TF_WORKSPACE"
#terraform13 workspace new $TF_WORKSPACE -no-color

# This should be set using the TF_WORKSPACE environment variable
#echo "Current workspace: $(terraform13 workspace show)"

# Configuring Autovars
if [[ -f "tfvars/${TFE_WORKSPACE}.tfvars" ]]; then
	echo "##[debug]Configuring Autovars"
    rm -rf tfvars/*.auto.tfvars
    rm -rf *.auto.tfvars
    cp tfvars/${TFE_WORKSPACE}.tfvars ${TFE_WORKSPACE}.auto.tfvars
fi

echo -e "vault_token = \"`vault login -token-only -tls-skip-verify -address="https://vault-cldsvc-prod.corp.internal.citizensbank.com/" -method=aws role=jenkins-aws-role`\"" > token.auto.tfvars

# Planning
if [[ "$TF_APPLY" = "No" && "$TERRAFORM_DESTROY" = "FALSE" ]]; then    
    # Target
    if [ -n "$TF_TARGET" ]; then
        echo "##[command]terraform13 plan -target"
        terraform13 plan -no-color $TF_TARGET
    else
        echo "##[command]terraform13 plan"
        terraform13 plan -no-color
    fi

elif [ "$TERRAFORM_DESTROY" = "TRUE" ]; then
    # Target
    if [ -n "$TF_TARGET" ]; then
        echo "##[command]terraform13 plan -destroy -target"
        terraform13 plan -destroy -no-color $TF_TARGET
    else
        echo "##[command]terraform13 plan -destroy"
        terraform13 plan -destroy -no-color
    fi
fi

status=$?
if [ $status -eq 1 ]; then
   echo "##[error]*****terraform13 planning issues found, fix your issues to proceed.*****"
fi

exit $status
