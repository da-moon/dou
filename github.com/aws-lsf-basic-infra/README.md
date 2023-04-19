# EDA On Cloud
## Documentation Reference
[LSF](https://www.ibm.com/docs/en/spectrum-lsf)

## POC Components
- OS: RHEL 7.9
- Cloud: AWS
- Infrastructure: Terraform
- Scheduler: IBM LSF
- Verification Tool:

## Deployment
### Pre requisites:
- AWS Account to deploy
- S3 bucket for backend
- IBM LSF installers and entitlement file in S3 bucket
- Terraform >= 1.1.9

Clone this repository
```bash
git clone https://github.com/DigitalOnUs/aws-lsf-basic-infra.git
```

### 1-env deployment
Go to 1-env/ and modify backend.tf
```
terraform {
  backend "s3" {
    bucket = "your-s3-bucket"
    key    = "env/terraform.tfstate"
    region = "your-region"
  }
}
```
Create your a file for terraform variables env.auto.tfvars. See example in varfiles/env.example.auto.tfvars

Export your AWS creds variables and run
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

A total of 22 resources will be created which will include
- VPC
- Security Group
- File System (OpenZFS)
- S3 bucket for logs
- IAM role
- 1 public subnet
- 2 private subnets

Once the 1-env deployment is completed proceed to 2-packer

### 2-packer AMI creation
Got to 2-packer/ and create a file for packer variables variables.pkrvars.hcl with the following variables
```
ami_name      = ""
instance_type = ""
region        = ""
source_ami    = ""
ssh_username  = ""
```
The base AMI should be RHEL 7.9
See example in varfiles/examples.pkrvars.hcl

To add the values for 
```
vpc_id        = "replace_with_your_vpi_id"
pub_subnet    = ["replace_with_your_public_subnet_id"]
role          = "replace_with_your_iam_role_id" 
```
Run
```bash
echo -n "vpc_id=" >> ../2-packer/your_file.pkrvars.hcl && terraform output vpc_id >> ../2-packer/your_file.pkrvars.hcl

echo -n "pub_subnets=" >> ../2-packer/your_file.pkrvars.hcl && terraform output pub_subnets >> ../2-packer/your_file.pkrvars.hcl
  
echo -n "role=" >> ../2-packer/your_file.pkrvars.hcl && terraform output role >> ../2-packer/your_file.pkrvars.hcl
```
File should look like something like this now
```
ami_name      = "eda-aws-ami"
instance_type = "t2.micro"
region        = "ca-central-1"
source_ami    = "ami-0277fbe7afa8a33a6"
ssh_username  = "ec2-user"
vpc_id        = "vpc-008471943b1ba86b9"
pub_subnet    = ["subnet-016a8aa080d401f32"]
role          = "eda-ec2-role" 
```
Once the variables are set run
```bash
packer build -var-file=variables.pkrvars.hcl .
```
The custom ami will be created and after the process finishes a manifest file will be created. This file will be used in the next step.

Once the 2-packer ami creation is completed and you see the manifest file under resource_connector/packer_manifest.json proceed to 3-ec2-instances

### 3-ec2-instances deployment
Go to 2-ec2-instances/ and modify backend.tf
```
terraform {
  backend "s3" {
    bucket = "your-s3-bucket"
    key    = "ec2-instance/terraform.tfstate"
    region = "your-region"
  }
}
```
Create your a file for terraform variables ec2.auto.tfvars. See example in varfiles/ec2.example.auto.tfvars

Then go to resource connector and update the files credentials and aws_creds. Make sure you follow the same format and leave a blank like at the end of each file.
*Don't change the first line in credentials file the role should be always [default]*

Export your AWS creds variables and run

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

A minimum of 3 resources will be created which will include
- AWS Key Pair
- Bastion Host
- Master Host

Bastion host will be created in the public subnet created in 1-env, Master host will be created in private subnet one of the 2 created in 1-env. 
User data script for each instance will:
- create poc users (lsfadmin, edauser2, edauser2)
- mount file system
- download installers from s3
- install IBM LSF
- patch IBM LSF installation
- create user group in IBM LSF cluster
only on master:
- enable resource connector
- enable mosquitto

You can validate the progress of the user data script inside each instance under /tmp/user_data.log

## Validation
SSH into bastion host
```bash
ssh-add ~/.ssh/your-key
ssh -A -i ~/.ssh/your-key ec2-user@public-bastion-ip
```
Run the following commands
```bash
lsid
```
This command should output the hostname of the master instance 
[Command Reference](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-lsid)

```bash
bhosts
```
This command should show one row in the table with the master hostname 
[Command Reference](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bhosts)

```bash
lshosts
```
This command should show 2 rows in the table one for master hostname and one for bastion host
[Command Reference](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-lshosts)

* Note that in order to run this commands you should wait until the user_data scripts finished. Each script will have a reboot at the end and after that you can perform the valdiations

## Usage

SSH into bastion host
```bash
ssh-add ~/.ssh/your-key
ssh -A -i ~/.ssh/your-key ec2-user@public-bastion-ip
```

Submit the job
```bash
bsub -R "awshost && pricing==spot" -q awsexample your-job
```
[Command Reference](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bsub)

This command will submit a job to awshost wich is configured to create a spot request and use the spot instance to execute the job

You can check the status of the job by running the following command. In case the command show `no unfinished jobs` you can add the flag `-d`
```bash
bjobs -w -u all
```
[Command Reference](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bjobs)

Other commands you can use to get details about the job are:
- [bpeek](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bpeek)
- [bkill](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bkill)
- [bqueues](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference-bqueues)

### Considerations
- If somehow your AWS credentials file are not correct at the moment of submitting a job, kill the job, fix the credentials and reboot the machine before sending a new job
- If the new instance is not provisioned within 10 minutes of creation the instance will die and spin up a new one

