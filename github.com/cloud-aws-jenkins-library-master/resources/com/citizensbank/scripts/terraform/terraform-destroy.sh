#!/bin/bash
cd ./spw

status=0

echo "##[command]terraform13 init"
terraform13 init -no-color

# terraform13 workspace new $TF_WORKSPACE
# This should be set using the TF_WORKSPACE environment variable
# echo "Current workspace: $(terraform13 workspace show)"

# Target
if [ -n "$TF_TARGET" ]; then
    echo "##[command]terraform13 destroy -target"
    terraform13 destroy -auto-approve -no-color $TF_TARGET
    status=$? 
else
    echo "##[command]terraform13 destroy"
    terraform13 destroy -auto-approve -no-color
    status=$?
fi

if [ $status -eq 3 ]; then
    echo "##[error]*****terraform13 issues found and will be published as failed.*****"
# else
#     echo "##[debug]List of the resources"
#     terraform13 state list
fi
exit $status
