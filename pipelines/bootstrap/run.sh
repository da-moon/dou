#!/bin/bash

set -x
set -euo pipefail

# relative to build-params.js script
PARAMS_FILE="../../parameters.json"


./../validate-template.sh

#PARAMETERS=$(node scripts/build-params.js "$PARAMS_FILE" "$BUCKET/$STACK_NAME")
STACK_NAME="nx-ci-cd-juan"
STACK_NAME=$(grep "ParameterStackName" "../../parameters" | awk '{print $3}' | sed 's|"||g')
MAIN_FILE="bootstrap.yaml"

EXISTING_STACKS=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" || echo '{"Stacks": []}')

EXISTING_STACK=$(echo $EXISTING_STACKS |
  jq -r '[.Stacks[] | select(.StackStatus!="DELETE_COMPLETE")][0].StackId')

echo "EXISTING_STACK: $EXISTING_STACK"

if [ "$EXISTING_STACK" == "" ] || [ "$EXISTING_STACK" == "null" ];
then
  echo 'creating stack!'
  aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body "file://$MAIN_FILE" \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --parameters "file://$PARAMS_FILE" \
    --disable-rollback \
    --timeout 120000

  echo "waiting for stack to finish creating..."
  aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME"
else
  echo "updating stack $STACK_NAME"
  aws cloudformation update-stack \
    --stack-name "$STACK_NAME" \
    --template-body "file://$MAIN_FILE" \
    --parameters "file://$PARAMS_FILE" \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND

  echo "waiting for stack to finish updating..."
  aws cloudformation wait stack-update-complete \
    --stack-name "$STACK_NAME"
fi