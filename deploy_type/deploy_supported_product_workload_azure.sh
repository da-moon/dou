#!/bin/sh

ls -la
pwd
env

ROOT=`pwd`
DEPLOY="${ROOT}/terraform_deploy"

echo "##################"
echo "##################"
echo "##################"

echo "Get commit hash for the code you want to promote."
echo "Remove .git and .circleci from code"

rm -rf .git*
rm -rf .circleci*

find . -type f \( -exec sha1sum "$PWD"/{} \; \) | awk '{print $1}' | sort | sha1sum | awk '{print $1}' > "${OUTPUT_DIR}/codeHash.txt"
codeHash=$(eval cat "${OUTPUT_DIR}/codeHash.txt")
echo "CODE HASH : $codeHash"

echo "mkdir ${DEPLOY}"
mkdir ${DEPLOY}

# Copy in service to deploy
echo "cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}"
cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}

#Copy modules too
echo "cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}"
cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}

echo "moving local.tf file"
echo "cp local.tf ${DEPLOY}"
cp local.tf ${DEPLOY}

if [ ${CIRCLE_BRANCH} = "develop" ]; then
  TERRAFORM_ENV=dev
elif [ ${CIRCLE_BRANCH} = "master" ]; then
  TERRAFORM_ENV=prod
else
  TERRAFORM_ENV=${CIRCLE_BRANCH}
fi

echo "Lets see what is in the local and in deploy\n"
ls -la
pwd
echo "local\n"
ls -la ${DEPLOY}



echo "Install Terraform for now \n"
echo "Where are we? "
pwd
ls -la
echo "curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip"
curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin
echo $PATH


echo "Move to terraform_deploy directory"
cd ${DEPLOY}
echo "Show all my files"
ls -la

echo "set my .terraformrc file"
mkdir ~/.terraform.d
touch ~/.terraform.d/credentials.tfrc.json
echo "{ \"credentials\": { \"app.terraform.io\": { \"token\": \"${TERRAFORM_CLOUD_API_TOKEN}\" } } }" >> ~/.terraform.d/credentials.tfrc.json

cat ~/.terraform.d/credentials.tfrc.json

echo "Init workspace first"
terraform init

workspace=''
echo "Select terraform workspace"
workspace='true'
echo "trying to select workspace with terraform workspace select $TERRAFORM_ENV"
terraform workspace select $TERRAFORM_ENV
if [ $? -ne 0 ]; then
   echo "$TERRAFORM_ENV workspace not available, create one"
   terraform workspace new $TERRAFORM_ENV
   if [ $? -ne 0 ]; then
      echo "Error selecting workspace terraform."
      workspace='false'
      exit 1
   fi
fi


terraform init

echo "Create deployment.auto.tfvars"
touch deployment.auto.tfvars
echo "touch deployment.auto.tfvars"
ls -la
pwd

printf "container_version = \"${codeHash}\"\n" >> deployment.auto.tfvars

printf "container_image   = \"${CONTAINER_IMAGE}\"\n" >> deployment.auto.tfvars

printf "run_env           = \"${TERRAFORM_ENV}\"\n" >> deployment.auto.tfvars

printf "project           = \"${TERRAFORM_PROJECT}\"\n" >> deployment.auto.tfvars

printf "azure_location        = \"${AZURE_LOCATION}\"\n" >> deployment.auto.tfvars

printf "landing_zone      = \"${LANDING_ZONE}\"\n" >> deployment.auto.tfvars

echo "You will be deploying your task with these variables : \n"
cat deployment.auto.tfvars
printf "AND \n"
echo "$(cat deployment.auto.tfvars)"


echo "Terraform apply"
if [ ${TERRAFORM_DESTROY} = "TRUE" ]; then
    terraform destroy -auto-approve -lock=true
else
    terraform apply -auto-approve -lock=true
fi
