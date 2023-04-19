#!/bin/bash

echo "##[group]Running tflint..."
echo "##[command]terraform init -input=false -backend=false"
terraform init -input=false -backend=false

echo "##[command]tflint --config $tflint_config"
tflint --config $tflint_config
status=$?
if [ $status -eq 3 ]; then
    echo "##[error]*****tflint issues found and will be published as failed tests.*****"
fi

echo "##[endgroup]"
exit $status