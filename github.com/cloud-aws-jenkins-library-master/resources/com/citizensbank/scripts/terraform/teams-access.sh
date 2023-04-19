#!/bin/bash +x

export TFE_TOKEN="$1"
export TFE_TEAM="team-GDxgBdyHB3pa8Qs"

echo "##[debug]Retrieving workspace ID"
WORKSPACE_ID=$(curl \
      --silent \
      --insecure \
      --header "Authorization: Bearer $TFE_TOKEN" \
      --header "Content-Type: application/vnd.api+json" \
      --request GET \
      https://$TFE_HOST/api/v2/organizations/$TFE_ORG/workspaces/$TFE_WORKSPACE | jq -r ".data.id")
echo "##[debug]Workspace ID is $WORKSPACE_ID"

TEAM_ID=($(curl \
    --silent \
    --insecure \
    --header "Authorization: Bearer $TFE_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request GET \
    https://$TFE_HOST/api/v2/organizations/$TFE_ORG/teams | jq -r ".data[].id" ))

for i in "${TEAM_ID[@]}"
do
  if ! test=$(curl \
            --silent \
            --insecure \
            --header "Authorization: Bearer $TFE_TOKEN" \
            --header "Content-Type: application/vnd.api+json" \
            --request GET \
            https://$TFE_HOST/api/v2/teams/$i | jq -r ".data.attributes.name" | grep -w "Terraform_Role_Vendor_Prod" ); then

    echo ""
  else
    echo "##[debug] The $i team was found"
    TFE_TEAM=$i
  fi
done

PAYLOAD=$(cat <<EOF
{
  "data": {
    "attributes": {
      "access": "custom",
      "runs": "apply",
      "variables": "none",
      "state-versions": "read-outputs",
      "plan-outputs": "none",
      "sentinel-mocks": "read",
      "workspace-locking": false
    },
    "relationships": {
      "workspace": {
        "data": {
          "type": "workspaces",
          "id": "$WORKSPACE_ID"
        }
      },
      "team": {
        "data": {
          "type": "teams",
          "id": "$TFE_TEAM"
        }
      }
    },
    "type": "team-workspaces"
  }
}
EOF
)

echo $PAYLOAD
check_access=$(curl \
    --silent \
    --insecure \
    --output /dev/null \
    --write-out '%{http_code}' \
    --header "Authorization: Bearer $TFE_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data "$PAYLOAD" \
    https://$TFE_HOST/api/v2/team-workspaces)

echo $check_access

if [ "$check_access" -eq 201 ]; then
  echo "##[debug] The team was added Successfully"
else
  echo "##[error]An error has occured while adding the access. Response code $check_access"    
fi