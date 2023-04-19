ROOT=$(pwd)
DEPLOY="${ROOT}/terraform_deploy"

echo "##################"
echo "##################"
echo "##################"

echo "Get commit hash for the code you want to promote."
echo "Remove .git and .circleci from code"

rm -rf .git*
rm -rf .circleci*

echo "mkdir ${DEPLOY}"
mkdir "${DEPLOY}"

# Copy in service to deploy
echo "cp -R ../devops.ci/supported_product_workloads/${SUPPORTED_PRODUCT_WORKLOAD}/* ${DEPLOY}"
cp -R ../devops.ci/supported_product_workloads/"${SUPPORTED_PRODUCT_WORKLOAD}"/* "${DEPLOY}"

#Copy modules too
echo "cp -R ../devops.ci/supported_product_workloads/modules ${ROOT}"
cp -R ../devops.ci/supported_product_workloads/modules "${ROOT}"

echo "moving .tf files"
cp local.tf "${DEPLOY}"
cp backend.tf "${DEPLOY}"