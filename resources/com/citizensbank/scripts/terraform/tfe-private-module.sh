#!/bin/bash +x

# INFO: https://www.terraform.io/docs/cloud/api/modules.html

export BITBUCKET_ORG="CLDREG"
export OAUTH_TOKEN_ID="ot-dsX27h3npnbHRkpw" 
export TFE_TOKEN="$1"

echo "##[debug]Seaching module into TFE"
echo "##[debug]Removing prefix..."
prefix="tfe-aws-"            
moduleName=${REPO_NAME#"$prefix"}
echo "##[debug]Module name: $moduleName"

code=$(curl \
  --silent \
  --insecure \
  --request GET \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://$TFE_HOST/api/v2/organizations/$TFE_ORG/registry-modules/private/$TFE_ORG/$moduleName/aws | jq -r ".data.attributes.name" )

echo "##[debug]Module found: $code"

if [ "$moduleName" == "$code" ]; then
  echo "##[debug]The $REPO_NAME is already uploaded into $TFE_ORG"
else
  echo "##[debug]Creating PAYLOAD"
  PAYLOAD=$(cat <<EOF
  {
    "data": {
      "attributes": {
        "vcs-repo": {
            "identifier":"$BITBUCKET_ORG/$REPO_NAME",
            "oauth-token-id":"$OAUTH_TOKEN_ID",
            "display_identifier":"$BITBUCKET_ORG/$REPO_NAME"
          }
      },
      "type":"registry-modules"
    }
  }
EOF
)

  echo "##[debug]PAYLOAD"
  echo $PAYLOAD
  echo "##[debug]Publishing the '$REPO_NAME' SSM on $TFE_ORG"

  status=$(curl \
    --silent \
    --insecure \
    --output /dev/null \
    --write-out '%{http_code}' \
    --header "Authorization: Bearer $TFE_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "$PAYLOAD" \
    https://$TFE_HOST/api/v2/organizations/$TFE_ORG/registry-modules/vcs)
  
  echo $status
  if [ "$status" -eq 201 ]; then
    echo "##[debug]Successfully published module version"
  elif [ "$status" -eq 404 ]; then
    echo "##[error]The user is not authorized. Response code $status"
  else
    echo "##[error]An error has occured while publishing the SSM. Response code $status"
  fi
fi
