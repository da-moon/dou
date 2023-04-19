#!/bin/sh

#---------------
# Where am I?
#---------------
pwd
ls -la
env

#-----------------------------
# Verify azure-cli installed
#-----------------------------
echo -e "\nAzure Version\n"
az -v

# Login to azure
echo -e "Service Principal credentials detected; logging in with Service Principal\n"
az login \
  --service-principal \
  --tenant $ARM_TENANT_ID \
  -u $ARM_CLIENT_ID \
  -p $ARM_CLIENT_SECRET

REPOSITORY=acr${CONTAINER_IMAGE}

login=$(az acr login --name ${REPOSITORY})
echo "login=$(az acr login --name ${REPOSITORY})"
# Our repository exists?
if [ -z "${login}" ]; then
    echo "Repository doesn't exist for ${REPOSITORY}, lets create it"
    echo "az acr create --resource-group valkyrie-test --name ${REPOSITORY} --sku Basic"
    az acr create --resource-group valkyrie-test --name ${REPOSITORY} --sku Basic
else
  echo "Repo exists"
fi

# Remove .git and .cricleci
echo "Get commit hash for the code you want to promote."
echo "Remove .git from code"
rm -rf .git*
rm -rf .circleci
ls -la

find . -type f \( -exec sha1sum "$PWD"/{} \; \) | awk '{print $1}' | sort | sha1sum | awk '{print $1}' > "${OUTPUT_DIR}/codeHash.txt"
codeHash=$(eval cat "${OUTPUT_DIR}/codeHash.txt")
echo "CODE HASH : $codeHash"

tagged=$(az acr repository show-tags --name acrwaas --repository waas | grep $codeHash)

if [ -z "${tagged}" ]; then
  az acr login --name ${REPOSITORY}
  echo "docker build -t ${REPOSITORY}.azurecr.io/${CONTAINER_IMAGE}:$codeHash ."
  docker build -t ${REPOSITORY}.azurecr.io/${CONTAINER_IMAGE}:$codeHash .
  echo "Check docker images to push"
  docker images
  echo "docker push ${REPOSITORY}.azurecr.io/${CONTAINER_IMAGE}:$codeHash"
  docker push ${REPOSITORY}.azurecr.io/${CONTAINER_IMAGE}:$codeHash
else
  echo "That version already exists, skipping"
fi
