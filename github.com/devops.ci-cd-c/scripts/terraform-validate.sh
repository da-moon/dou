#!/bin/bash

echo "##[debug]Setting empty provider block"
cat <<EOF > provider.tf
provider "aws" {
}
EOF

echo "##[command]terraform init -input=false"
terraform init -input=false
    
if [ "$SKIP_TF_VALIDATE" = "False" ]; then
    echo "##[command]terraform validate"
    terraform validate
else
    echo "##[debug]Skipping terraform validate as SKIP_TF_VALIDATE is $SKIP_TF_VALIDATE"
fi
  
echo "##[command]terraform fmt -check -recursive"
terraform fmt -check -recursive
status=$?
if [ $status -eq 3 ]; then
    echo "##[error]*****terraform formatting issues found, fix your formatting with terraform fmt -recursive to proceed.*****"
fi

exit $status