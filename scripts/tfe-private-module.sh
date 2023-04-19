#!/bin/bash

echo "##[debug]Removing prefix..."
prefix="terraform-aws-"            
moduleName=${CIRCLE_PROJECT_REPONAME#"$prefix"}
echo "##[debug]Module name: $moduleName"

code=$(curl \
  --silent \
  --request GET \
  --header "Authorization: Bearer $TERRAFORM_API" \
  --header "Content-Type: application/vnd.api+json" \
  https://$TFE_HOST/api/v2/organizations/$TFE_ORG/registry-modules/private/$TFE_ORG/$moduleName/aws | jq -r ".data.attributes.name" )

echo "##[debug]The module name: $code"

if [ "$moduleName" == "$code" ]; then
  echo "##[debug]The $CIRCLE_PROJECT_REPONAME is already uploaded into $TFE_ORG"
else
  echo "##[debug]Creating PAYLOAD"
  PAYLOAD=$(cat <<EOF
  {
    "data": {
      "attributes": {
        "vcs-repo": {
            "identifier":"$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME",
            "oauth-token-id":"$OAUTH_TOKEN_ID",
            "display_identifier":"$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME"
          }
      },
      "type":"registry-modules"
    }
  }
EOF
)

  echo "##[debug]PAYLOAD"
  echo $PAYLOAD
  echo "##[debug]Publishing the '$CIRCLE_PROJECT_REPONAME' SSM on $TFE_ORG"

  status=$(curl \
    --silent \
    --output /dev/null \
    --write-out '%{http_code}' \
    --header "Authorization: Bearer $TERRAFORM_API" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "$PAYLOAD" \
    https://$TFE_HOST/api/v2/organizations/$TFE_ORG/registry-modules/vcs)
  
  if [ "$status" -eq 201 ]; then
    echo "##[debug]Successfully published module version"
  else
    echo "##[error]An error has occured while publishing the SSM. Response code $status"
    exit 1
  fi
fi
