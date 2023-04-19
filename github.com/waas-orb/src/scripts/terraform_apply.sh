ROOT=$(pwd)
DEPLOY="${ROOT}/terraform_deploy"
TERRAFORM_ERROR="FALSE"

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
  echo "run_env           = \"${TERRAFORM_ENV}\""
  echo "project           = \"${TERRAFORM_PROJECT}\""
  echo "aws_region        = \"${AWS_DEFAULT_REGION}\""
  echo "landing_zone      = \"${LANDING_ZONE}\""
} >> deployment.auto.tfvars

printf "You will be deploying your task with these variables : \n"
cat deployment.auto.tfvars

if [ "${TERRAFORM_DESTROY}" = "FALSE" ]; then
    echo "Terraform apply"
    if terraform apply -auto-approve -lock=true; then
      echo "Succeeded apply"
    else
      echo "Error, now time to run Terraform destroy"
      TERRAFORM_ERROR="TRUE"
      TERRAFORM_DESTROY="TRUE"
    fi
fi

if [ "${TERRAFORM_DESTROY}" = "TRUE" ]; then
    terraform destroy -auto-approve -lock=true
fi

if [ "${TERRAFORM_ERROR}" = "TRUE" ]; then
    exit 1
fi