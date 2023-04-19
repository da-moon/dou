#!/bin/bash

cd ./fmt

ls

echo "##[group]Running terraform fmt..."
echo "##[command]terraform13 fmt"
terraform13 fmt -recursive

echo "##[command]Config Git"
git config user.name 'Jenkins CI'

echo "##[command]git add"
git add .

echo "##[command]git commit"
git commit -m "Terraform FMT from Jenkins Pipeline"

echo "##[command]git push"
git push origin HEAD:${BRANCH_NAME}
status=$?

if [ $status -eq 3 ]; then
	echo "##[error]*****tf fmt cannot be pushed to GIT. Verify locally and then retry.*****"
else
	echo "##[debug]*****tf fmt pushed successfully.*****"
fi
