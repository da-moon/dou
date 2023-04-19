#!/bin/bash
REGISTRY="${ECR_REGISTRY}"
PATH=$PATH:/usr/local/bin

deploy_stack() {
    STACK_NAME=tc-stack
    cd /usr/Siemens/Teamcenter13/teamcenter_root/container
    echo ">> Deleting stack if it exists"
    docker stack rm "$STACK_NAME"
    sleep 30
    echo ">> login to ECR"
    aws ecr get-login-password | docker login \
        --username AWS \
        --password-stdin "$REGISTRY"
    #preserve original yamls
    echo ">> Backup Yaml files"
    mkdir /tmp/stacks
    cp *.yml /tmp/stacks
    echo ">> use images from ECR"
    sed -i -e "s/siemens\/teamcenter/$REGISTRY\/siemens\/teamcenter/" *.yml
    echo ">> Deploying stack"
    docker stack deploy -c tc_microservice_framework.yml "$STACK_NAME"
    sleep 10
    docker stack deploy -c microserviceparameterstore.yml "$STACK_NAME"
    sleep 3
    docker stack deploy -c file-repo.yml "$STACK_NAME"
    sleep 3
    docker stack deploy -c tcgql.yml "$STACK_NAME"
    sleep 3
    docker stack deploy -c darsi.yml "$STACK_NAME"
    echo ">> Restore Yaml files"
    cp /tmp/stacks/*.yml /usr/Siemens/Teamcenter13/teamcenter_root/container
}

deploy_stack

