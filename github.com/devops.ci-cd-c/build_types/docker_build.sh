#!/bin/sh

#check environment variables
ls -la
env
aws --version
# Get all repositories
repos=$(aws ecr describe-repositories --region $AWS_DEFAULT_REGION | grep $CONTAINER_IMAGE)

echo "FOUND : $repos"
# Our repository exists?
if [ -z "${repos}" ]; then
    echo "ECR doesn't exist for ${CONTAINER_IMAGE}, lets create it"
  aws ecr create-repository --repository-name $CONTAINER_IMAGE
else
  echo "Repo exists"
fi

echo "Get commit hash for the code you want to promote."
echo "Remove .git from code"
pwd
ls -la
#taking hash of code.

rm -rf .git*
rm -rf .circleci


find . -type f \( -exec sha1sum "$PWD"/{} \; \) | awk '{print $1}' | sort | sha1sum | awk '{print $1}' > "${OUTPUT_DIR}/codeHash.txt"
codeHash=$(eval cat "${OUTPUT_DIR}/codeHash.txt")
echo "CODE HASH : $codeHash"

echo "existingSha=\$(aws ecr list-images --region $AWS_DEFAULT_REGION --repository-name ${CONTAINER_IMAGE} | grep ${codeHash})"
existingSha=$(aws ecr list-images --region $AWS_DEFAULT_REGION --repository-name ${CONTAINER_IMAGE} | grep ${codeHash})

if [ -z "${existingSha}" ]; then
      echo "Lets build an docker container and store it in aws"
      AWS_ECR_REPO_URL=$(aws ecr describe-repositories --region ${AWS_DEFAULT_REGION} | grep ${CONTAINER_IMAGE} | grep repositoryUri | awk '{split($0,a,":"); print a[2]}' | cut -f 1 -d ',' | sed -e 's/^"//' -e 's/"$//' | tr -d '"')
      echo "AWS_ECR_REPO_URL is $AWS_ECR_REPO_URL"
      aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ECR_REPO_URL
      something=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION)
      echo "docker build -t $AWS_ECR_REPO_URL:$codeHash ."
      docker build -t $AWS_ECR_REPO_URL:$codeHash .
      echo "docker push $AWS_ECR_REPO_URL:$codeHash"
      docker push $AWS_ECR_REPO_URL:$codeHash
else
  # Create ECR
  echo "Container : ${CONTAINER_IMAGE}, version : ${codeHash} already exists."
fi
