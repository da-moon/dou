Introduction
This is a sample WaaS Scaffolding repo for infrastructure deployemtns which refers to an exisiting tfe-aws-pattern and deploys an application with the help of userdata or the IIDK image

Dwarf.config usage
Populate Dwarf.config with below variables as per app teams requirements



LANDING_ZONE	Name of the Cloud Provider (AWS, AZURE)
SUPPORTED_PRODUCT_WORKLOAD	Name of pattern
SUPPORTED_PRODUCT_WORKLOAD_VERSION	Version of the pattern
TERRAFORM_DESTROY	TF Destroy selection
The AMI that will be used is based on the provided OS variable in the tf var file which refers to latest hardenend ami

If using a custom ami for a specific app, the AMI id will need to be passed in the tfvars file.

Here is an example of the declaration: https://bitbucket.corp.internal.companyA.com/projects/CLDDO/repos/tfe-aws-alb-asg-pattern/browse/data.tf

tfvars
See tfvars/dev-cfg-consumer-dev.tfvars for example

Jenkinsfile
Jenkinsfile uses the shared jenkins libraries in the repo - https://bitbucket.corp.internal.xxxxxxxx.com/projects/CLDDO/repos/cloud-aws-jenkins-library/browse

userdata.tpl
Is used for passing script for setting up instance/install or configure your instance.

You can find more about WaaS structure folders in the documentation: https://confluence.corp.internal.xxxxxxxx.com/display/CLSE/WaaS+Framework
