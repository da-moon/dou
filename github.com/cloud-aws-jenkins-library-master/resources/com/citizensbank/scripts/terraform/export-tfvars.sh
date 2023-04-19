#!/bin/bash +x

# Configuring Autovars
if [[ -f "tfvars/$ENV_NAME.tfvars" ]]; then
	echo "##[debug]Configuring Autovars"
    rm -rf tfvars/*.auto.tfvars
    rm -rf *.auto.tfvars
    cp tfvars/$ENV_NAME.tfvars $ENV_NAME.auto.tfvars
fi

echo -e "vault_token = \"`vault login -token-only -tls-skip-verify -address="https://vault-cldsvc-prod.corp.internal.citizensbank.com/" -method=aws role=jenkins-aws-role`\"" > token.auto.tfvars
