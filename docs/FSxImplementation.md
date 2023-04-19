## Amazon FSx OpenZFS Introduction and Usage in EDA on cloud
### Overview

The [Amazon FSx for OpenZFS ](https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/what-is-fsx.html)  is a fully managed file storage service that makes it easy to move data residing in on-premises ZFS or other Linux-based file servers to AWS without changing your application code or how you manage data

Amazon FSx for OpenZFS is available in the following AWS Regions:
* US East (N. Virginia)
* US East (Ohio)
* US West (Oregon)
* Europe (Ireland)
* Europe (Frankfurt)
* Europe (London)
* Asia Pacific (Tokyo)
* Asia Pacific (Singapore)
* Asia Pacific (Sydney)

### Features
<<required??? >>

### IAM Permissions
To ensure that users and roles can still use the Amazon FSx console, also attach the Amazon FSx "AmazonFSxConsoleFullAccess" or "AmazonFSxConsoleReadOnlyAccess" AWS managed policy to the entities.

#### Terraform Resource

The code is available in modules/fsx folder
```sh
resource "aws_fsx_openzfs_file_system" "test" {
  storage_capacity    = 64
  subnet_ids          = [aws_subnet.test1.id]
  deployment_type     = "SINGLE_AZ_1"
  throughput_capacity = 64
}
```

### Manual commands to mount FSx OpenZFS on a VM
```sh
mkdir /fsx
## To ensure fsx mount remains even after rebooting VM
echo "${FSX_DNS}:/fsx   /fsx    nfs      defaults        0 0" | tee -a /etc/fstab > /dev/null
mount -t nfs -o nfsvers=4.1 ${FSX_DNS}:/fsx/ /fsx >> /tmp/user_data.log 2>&1
## to verify the mount run : df -k 
```

### Usage in the Project (EDA on Cloud)

* Technical implementation 
FSX is created as a part of 1-env folder.
In 2-packer and 3-ec2-instance terraform apply, this FSx gets mounted on bastion , master and rc-worker nodes.

* Functional Implementation
FSx is required so that a jobs that gets submitted to bastion host can be run on rc-worker which gets spinned up usinf IBM LSF resource connector. This FSx act as a common mountpoint across all VMs to be able to execute any EDA/general jobs using bsub command.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

### Security Ports
* [Security Ports] (https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/limit-access-security-groups.html)
* [IAM Role] (https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/security_iam_id-based-policy-examples.html)

### Testing
Calling the module from root main.tf (1-env folder)
```sh
module "openzfs" {
  source              = "../modules/fsx"
  fsx_name            = var.fsx_name
  storage_capacity    = var.storage_capacity
  throughput_capacity = var.throughput_capacity
  subnet_ids          = [module.vpc.public_subnets[0]]
  security_group_ids  = [module.security-group.security_group_id]
}
```

* terraform init
* terraform plan
* terraform apply

#### References
* [FSX Getting started](https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/getting-started.html) 
* [About FSx OpenZFS](https://aws.amazon.com/fsx/openzfs/)
