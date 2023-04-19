#!/bin/bash

OWN_DIR="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

REPO_NAME=$(grep "ParameterRepoName" "parameters" | awk '{print $3}' | sed 's|"||g')
REPO_DESC=$(grep "ParameterRepoDescription" "parameters" | awk '{print $3}' | sed 's|"||g')
REGION=$(grep "ParameterRegion" "parameters" | awk '{print $3}' | sed 's|"||g')

check_prerequisites() {

    if ! pip3 > /dev/null 2>&1 && ! pip > /dev/null 2>&1 ; then
        echo "Dependency \"pip3\" or \"pip\" for python 3 is needed but was not found. Please install it depending on your OS." && exit 1
    fi

    if ! git version > /dev/null 2>&1 ; then
        echo "Dependency \"git\" is needed but was not found. Please install it depending on your OS." && exit 1
    fi

    if pip3 > /dev/null 2>&1 ; then
        if ! pip3 --disable-pip-version-check list | grep "git-remote-codecommit" > /dev/null 2>&1 ; then
            pip3 install git-remote-codecommit
        fi
    elif pip > /dev/null 2>&1 ; then
        if ! pip --disable-pip-version-check list | grep "git-remote-codecommit" > /dev/null 2>&1 ; then
            pip install git-remote-codecommit
        fi
    fi
}

push_code() {

    git --version
    if [ ! -d ".git" ] ; then
    git init
    fi

    if git remote | grep "aws" ; then
    git remote remove aws
    fi

    git config user.email "cloudformation@cloudformation.com"
    git config user.name "cloudformation script"
    git config --global credential.helper "!aws codecommit credential-helper $@"
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git remote add aws codecommit::$REGION://$REPO_NAME
    git remote -v
    git add .
    git commit -m "add last changes" 
    git push aws "$BRANCH":main
}
install() {
    cd "$OWN_DIR/pipelines/bootstrap"
    ./run.sh
}

check_prerequisites

cd "$OWN_DIR"
echo "$OWN_DIR"

aws codecommit create-repository --repository-name "$REPO_NAME" --repository-description "$REPO_DESC" 
push_code
install