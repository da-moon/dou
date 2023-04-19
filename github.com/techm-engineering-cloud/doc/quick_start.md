# Quick Start

## Prerequisites

* AWS account with permissions to create, read, update and delete IAM roles and policies, CodeCommit repositories, CodeBuild projects, and CodePipeline pipelines.
* An existing S3 bucket where CI/CD artifacts will be stored. Its name should be configured in the file `boostrap/bootstrap.tfvars`, property `bootstrap_bucket_name`. The bucket should be encrypted and have versioning enabled.
* A machine (can be a local laptop) where the initial `install.sh` script will be run. This is only needed the first time for bootstrapping the installation. The machine should have valid AWS credentials and `terraform` 1.1.x installed.

## Initial installation

* Copy the contents of the folder `doc/environments_example` into `environments`, and change the variables as needed according to your installation.
* Run the script `install.sh`
* Verify in AWS that a CodeCommit repository named `[installation_prefix-][vcs_reponame]` was crated with the contents of this package.
* Verify in AWS that a CodePipeline pipeline named `[installation_prefix-]eng-cloud-bootstrap` was created and run successfully.

After the above steps, all changes to the environment can be checked in to the CodeCommit repository and they will be deployed by CodePipeline automatically.

