#!/bin/bash

ERROR_COUNT=0;

echo "Validating AWS CloudFormation templates..."

cd ../../

# TODO: validate in parallel
for TEMPLATE in $(find techm-nx-engineering-cloud/pipelines -name '*.yaml'); do

  # Validate the template with CloudFormation
  ERRORS=$(aws cloudformation validate-template --template-body file://$TEMPLATE 2>&1 >/dev/null);
  if [ "$?" -gt "0" ]; then
    ((ERROR_COUNT++));
    echo "[fail] $TEMPLATE: $ERRORS";
  else
    echo "[pass] $TEMPLATE";
  fi;

done;

echo "$ERROR_COUNT template validation error(s)";
if [ "$ERROR_COUNT" -gt 0 ];
  then exit 1;
fi