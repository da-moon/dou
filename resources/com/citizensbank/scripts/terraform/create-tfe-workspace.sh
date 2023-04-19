#!/bin/bash +x

export TFE_TOKEN="$1"

function validate_args(){
    echo "##[debug]Verifying the provided arguments..."
    if [ -n "$TFE_TOKEN" ] && [ -n "$TFE_HOST" ] && [ -n "$TFE_ORG" ] && [ -n "$TFE_WORKSPACE" ]; then
        echo "##[debug]Verification sucessful!"
    else
        echo "##[error]Missing or invalid arguments. Verify your inputs and restart the script."
        exit 1
    fi
}

function verify_tfe_org() {
    if ! check_org=$(curl \
        --silent \
        --insecure \
        --header "Authorization: Bearer $TFE_TOKEN" \
        --header "Content-Type: application/vnd.api+json" \
        --request GET \
        https://$TFE_HOST/api/v2/organizations | jq -r ".data[].attributes.name" | grep -w "$TFE_ORG"); then
        echo "##[error]Organization doesn't exist on Terraform enterprise"
        exit 1
    else
        echo "##[debug]Organization name provided has been validated"
    fi
}

function create_tfe_workspace() {
    echo "##[debug]Verifying if workspace $TFE_WORKSPACE doesn't exist already in organization $TFE_ORG"
    check_ws_response=$(curl \
        --silent \
        --insecure \
        --output /dev/null \
        --write-out '%{http_code}' \
        --header "Authorization: Bearer $TFE_TOKEN" \
        --header "Content-Type: application/vnd.api+json" \
        --request GET https://$TFE_HOST/api/v2/organizations/"$TFE_ORG"/workspaces/"$TFE_WORKSPACE")

    if [ "$check_ws_response" -eq 404 ]; then
        echo "##[debug]Creating workspace $TFE_WORKSPACE"
        echo "##[debug]Creating payload configuration"
        PAYLOAD=$(cat <<EOF
{
"data": {
    "attributes": {
        "name": "$TFE_WORKSPACE",
        "allow-destroy-plan": true,
        "auto-apply": true,
        "terraform_version": "0.13.6",
        "execution-mode": "remote",
        "working-directory": "$TFE_WORKING_DIRECTORY"
    },
    "type": "workspaces"
    }
}
EOF
)
        create_ws_response=$(curl \
        --silent \
        --insecure \
        --output /dev/null \
        --write-out '%{http_code}' \
        --header "Authorization: Bearer $TFE_TOKEN" \
        --header "Content-Type: application/vnd.api+json" \
        --request POST \
        --data "$PAYLOAD" https://$TFE_HOST/api/v2/organizations/"$TFE_ORG"/workspaces/)

        if [ "$create_ws_response" -eq 201 ]; then
            echo "##[debug]Workspace $TFE_WORKSPACE has been created successfully within organization $TFE_ORG"
        else
            echo "##[error]An error has occured while creating the workspace. Response code $create_ws_response"
            exit 1
        fi
    else
        echo "##[error]Workspace $TFE_WORKSPACE already exists within organization $TFE_ORG"
        exit 1
    fi
}
  

validate_args
verify_tfe_org

create_tfe_workspace

echo "##[debug]Retrieving workspace ID"
    WORKSPACE_ID=$(curl \
      --silent \
      --insecure \
      --header "Authorization: Bearer $TFE_TOKEN" \
      --header "Content-Type: application/vnd.api+json" \
      --request GET \
      https://$TFE_HOST/api/v2/organizations/"$TFE_ORG"/workspaces/"$TFE_WORKSPACE" | jq -r ".data.id")
echo "##[debug]Workspace ID is $WORKSPACE_ID"