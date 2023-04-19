ROOT=$(pwd)
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

AWS_ECR_REPO_URL=$(aws ecr describe-repositories --region "$AWS_DEFAULT_REGION" | grep "${CONTAINER_IMAGE}" | grep repositoryUri | awk '{split($0,a,":"); print a[2]}' | cut -f 1 -d ',' | sed -e 's/^"//' -e 's/"$//' | tr -d '"'| sed -e 's/^[ \t]*//')

echo "AWS_ECR_REPO_URL is $AWS_ECR_REPO_URL"

if [ -z "${AWS_ECR_REPO_URL}" ]; then
  echo "Container : ${CONTAINER_IMAGE} version : $codeHash doesn't exist to deploy"
  exit 1
fi

echo "mkdir ${DEPLOY}"
mkdir "${DEPLOY}"

# Copy in service to deploy
echo "cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}"
cp -R ../devops.ci/supported_product_workloads/"${SUPPORTED_PRODUCT_WORKLOAD}"/* "${DEPLOY}"

#Copy modules too
echo "cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}"
cp -R ../devops.ci/supported_product_workloads/modules "${ROOT}"

echo "moving local.tf file"
echo "cp local.tf ${DEPLOY}"
cp local.tf "${DEPLOY}"

if [ "${CIRCLE_BRANCH}" = "develop" ]; then
  TERRAFORM_ENV=dev
elif [ "${CIRCLE_BRANCH}" = "master" ]; then
  TERRAFORM_ENV=prod
else
  TERRAFORM_ENV="${CIRCLE_BRANCH}"
fi

printf "Lets see what is in the local and in deploy\n"
ls -la
pwd
printf "local\n"
ls -la "${DEPLOY}"

printf "Install Terraform for now \n"
echo "Where are we? "
pwd
ls -la
echo "curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip"
curl -L https://releases.hashicorp.com/terraform/"${TERRAFORM_VERSION}"/terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip --output terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin
echo "$PATH"


echo "Move to terraform_deploy directory"
cd "${DEPLOY}" || exit
echo "Show all my files"
ls -la

echo "set my .terraformrc file"
mkdir ~/.terraform.d
touch ~/.terraform.d/credentials.tfrc.json
echo "{ \"credentials\": { \"app.terraform.io\": { \"token\": \"${TERRAFORM_CLOUD_API_TOKEN}\" } } }" >> ~/.terraform.d/credentials.tfrc.json

cat ~/.terraform.d/credentials.tfrc.json

echo "Init workspace first"
terraform init

echo "Select terraform workspace"
echo "trying to select workspace with terraform workspace select $TERRAFORM_ENV"

if ! terraform workspace select "$TERRAFORM_ENV" ; then
   echo "$TERRAFORM_ENV workspace not available, create one"
   terraform workspace new "$TERRAFORM_ENV"
   if ! terraform init ; then
      echo "Error selecting workspace terraform."
      exit 1
   fi
fi

terraform init

echo "Create deployment.auto.tfvars"
touch deployment.auto.tfvars
echo "touch deployment.auto.tfvars"

{
  echo "container_version = \"${codeHash}\""
  echo "container_image   = \"${AWS_ECR_REPO_URL}\""
  echo "run_env           = \"${TERRAFORM_ENV}\""
  echo "project           = \"${TERRAFORM_PROJECT}\""
  echo "aws_region        = \"${AWS_DEFAULT_REGION}\""
  echo "landing_zone      = \"${LANDING_ZONE}\""
} >> deployment.auto.tfvars

printf "You will be deploying your task with these variables : \n"
cat deployment.auto.tfvars

echo "Terraform apply"
if [ "${TERRAFORM_DESTROY}" = "TRUE" ]; then
    terraform destroy -auto-approve -lock=true
else
    terraform apply -auto-approve -lock=true
fi
