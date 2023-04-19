## Packer Implementation

## Packer Reference:

[Packer](https://www.packer.io/docs)
[Packer Manifest and Post processor](https://www.packer.io/docs/post-processors/manifest)

Requirements:
- Packer Version 1.7.8

#### Required Files
Packer will require the following files available locally on your machine
- terraform_output/fsx_openzfs_dns_name
- <your-file>.pkvars.hcl
- variables.pky.hcl 
- eda-aws-ami.pkr.hcl (source code)
- scripts/ec2_user_data_file_ami.sh

###### variables.pkr.hcl
Consists of default values for the variables used in source code.
Please note that you need to set the source_ami default value , else the packer will throw error.
This value can be overwritten in pkvars.hcl file.

###### <your-file>.pkvars.hcl
Created by the user with the following parameters (if not specified default will be picked up)

```sh
ami_name      = "eda-aws-ami"
instance_type = "t2.micro"
region        = "eu-west-1"
source_ami    = "ami-002d3240b69a0ef4e"
ssh_username  = "ec2-user"
```

#### Values for VPC , subnet and Role

Values for these variables are extracted from output of 1-env and fed to <your-file>.pkrvars.hcl

example values:
```sh
vpc_id = "vpc-0a5db5bc5d38a"
pub_subnets = [
  "subnet-09199c533c9411",
]
role          = "eda-ec2-role"
```

To get the values or refer to README documentation under 2-packer folder.

Run this command in the following path ./1-env:
```
echo -n "vpc_id=" >> ../2-packer/your-file.pkrvars.hcl && terraform output vpc_id >> ../2-packer/your-file.pkrvars.hcl
echo -n "pub_subnets=" >> ../2-packer/your-file.pkrvars.hcl && terraform output pub_subnets >> ../2-packer/your-file.pkrvars.hcl
echo -n "role=" >> ../2-packer/your-file.pkrvars.hcl && terraform output role >> ../2-packer/your-file.pkrvars.hcl
```

your-file.pkrvars.hcl will get updated locally and you are ready to run the below commands to build image.

###### Commands

Please make sure to export AWS secret key and access key before 

```sh
packer init .
packer fmt .
packer validate .
packer build -var-file=variables.pkrvars.hcl 
```

###### Image Creation

[LSF Cloud Image](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=connector-building-cloud-image)

In this project, packer will be used to build a custom AMI using a standard RHEL 7.9 AMI available on community AMIs of AWS.
The custom image is fed to Resource connector awsprov_templates.json.
This image will be used as base image once resource connector have to create an instance per request. The intention of this image is having all the required components already installed so the provisioning process is faster.

On the LSF installation side this image requires few mandatory parameters in the installation file
- LSF will be installed with no role assigned to this particular instance just the reference of Management Host as Master and Server Host 
- Local Resources should be defined to specify this isntance will be tagged as awshost
- In case you are using spot instances a local resource for that should be defined too. See example below
```sh
LSF_TOP="/usr/share/lsf"
LSF_ADMINS="lsfadmin ec2-user"
LSF_CLUSTER_NAME="verification_cluster"
LSF_MASTER_LIST="${LSF_MASTER_IP}"
LSF_SERVER_HOSTS="${LSF_MASTER_IP}"
LSF_ENTITLEMENT_FILE="/usr/share/lsf_files/lsf_distrib/lsf_std_entitlement.dat"
LSF_TARDIR="/usr/share/lsf_files/"
LSF_LOCAL_RESOURCES="[resource awshost] [resource define_ncpus_threads] [resourcemap spot*pricing]"
LSF_LIM_PORT="7869"
CONFIGURATION_TEMPLATE="HIGH_THROUGHPUT"
SILENT_INSTALL="Y"
LSF_SILENT_INSTALL_TARLIST="All"
ACCEPT_LICENSE="Y"
ENABLE_EGO="Y"
EGO_DAEMON_CONTROL="Y"
ENABLE_DYNAMIC_HOSTS="Y"
```
According to Resource Connector documentation, the cloud image should have the daemons enabled manually. For this case ego will start the daemons in this image since we have it enabled from the beggining.

Across the cluster script hostsetup has been used to configure the instance on LSF, in this particular case hostsetup will not be used in the AMI creation however if you want to validate if the image is being constructed correctly you can run the following commands and the instance created from this AMI should immediatly join the cluster.
Based on that information the below commands have been added to the user_data.sh in the Resource Connector files. See ResourceConnector.md for details.

```sh
./hostsetup --top="/usr/share/lsf" --boot="y"
lsadmin limstartup
```


###### Usage
The AMI is built and available in the region you have specified.

3-ec2-instance folder spins up a master and bastion host.
In the master script ( ec2_user_data_file_master.sh), the custom AMI value is read and added to awsprov_template.json

```sh
CUSTOM_AMI=$(jq -r '.builds[-1].artifact_id' /home/ec2-user/resource_connector/packer_manifest.json | cut -d ":" -f2)
sed -i "s/_AMI_/${CUSTOM_AMI}/g" /home/ec2-user/resource_connector/awsprov_templates.json
```

Note: the jq command retrives the last build artifact from packer_manifest.json file.
JQ should be installed on all nodes.
