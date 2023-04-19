#!/bin/bash

echo "##[command]terraform13 init -input=false"
terraform13 init -no-color -input=false

echo "##[command]terraform13 validate"
terraform13 validate -no-color

echo "##[command]terraform13 fmt -check -recursive"
terraform13 fmt -check -recursive -diff
status=$?
if [ $status -eq 3 ]; then
	echo "##[error]*****terraform13 formatting issues found, fix your formatting with terraform13 fmt -recursive to proceed.*****"
	terraform13 fmt -recursive
fi

exit $status
