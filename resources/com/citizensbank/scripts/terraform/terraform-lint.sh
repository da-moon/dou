#!/bin/bash

echo "##[group]Running tflint..."
echo "##[command]terraform init -input=false -backend=false"
terraform13 init -input=false -backend=false -no-color

echo "##[command]tflint --init"
/opt/tflint/tflint --init

echo "##[command]tflint --config $tflint_config"
/opt/tflint/tflint --config $tflint_config
status=$?

if [ $status -eq 3 ]; then
	echo "##[error]*****tflint issues found and will be published as failed tests.*****"
else
	echo "##[debug]*****tflint passed successfully.*****"
fi

echo "##[endgroup]"
exit $status
