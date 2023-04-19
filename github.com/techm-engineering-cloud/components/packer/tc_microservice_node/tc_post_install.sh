#!/bin/bash

REGISTRY="${ECR_REGISTRY}"
set -ex

upload_images() {
    echo ">>> Listing available docker images"
    docker image ls
    IMAGES=$(docker image ls --format $(echo -e "\u007B\u007B.Repository\u007D\u007D:\u007B\u007B.Tag\u007D\u007D"))

    echo $IMAGES
    
    REGION=$(echo $REGISTRY | sed 's|\.amazonaws\.com||; s|.*\.||')
    aws ecr get-login-password --region=$REGION | docker login \
        --username AWS \
        --password-stdin "$REGISTRY" 

    echo "Repositories: $(aws ecr describe-repositories --region=$REGION | jq -r '[.repositories[].repositoryName]')"
    
    for image in $IMAGES; do
        if [[ "$image" =~ ^siemens.*  ]]; then
            echo "[Tagging] $image to $REGISTRY/$image"
            docker tag $image $REGISTRY/$image
            echo "[Pushing] $REGISTRY/$image..."
            docker push $REGISTRY/$image
        fi
    done
}

regenerate_secrets() {
    echo "Regenerating secrets"
    cd /usr/Siemens/Teamcenter13/teamcenter_root/jwt_config_tool
    mkdir -p /usr/Siemens/Teamcenter13/teamcenter_root/signer_config
    chmod +x generate_keystore
    KEYSTORE_PWD=$(aws secretsmanager get-secret-value --secret-id=${KEYSTORE_SECRET_NAME} | jq -r '.SecretString')
    ./generate_keystore '$KEYSTORE_PWD'
    cp signer_config/* ../container/secrets/
    cp validator_config/* ../container/secrets/
    cp signer_config/* ../signer_config/
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container/secrets/
    if [ -f "signer_tc_micro_security.properties" ]; then
        mv signer_tc_micro_security.properties signer_tc_micro_security.properties.bkp
        cp tc_micro_security.properties signer_tc_micro_security.properties
    fi
}

upload_images
regenerate_secrets

