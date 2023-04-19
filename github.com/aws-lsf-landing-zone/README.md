# aws-lsf-landing-zone

### AWS Terraform infrastructure to deploy an AWS Landing Zone VPC

--- 

## Requiriments

### Authenticate in aws
go to the **scripts** folder and replace the values of the ***aws_config.sh*** file with your AWS credentials and run it

![script](/docs/img/aws_script.png)

---

## Variables

This module needs a set of variables:

- region: the aws region where your resources will be deployed
- azs: A list of availability zones names or ids in the region
- name:  Name to be used on all the resources as identifier
- cidr: The CIDR block for the VPC
- priv_sub: A list of private subnets inside the VPC
- pub_sub: A list of public subnets inside the VPC
- gateway: Should be true if you want to create a new VPN and NAT Gateway resource and attach it to the VPC

You can find and example of these variables in the ```/varfiles/*.example.auto.tfvars``` file

![vars](/docs/img/vars_example.png)

---

## Backend
This VPC uploads the .tfstate file to a S3 Bucket, you can find it in the ```/vpc/backend.tf``` file and modify (if you want) with the name of the S3 bucket and the path of your preference

---

## Run

Go to ```/vpc/``` folder and create a ***.terraform.auto.tfvars** file and put the values that you want, after that run:

- ```terraform init```
- ```terraform plan```
- ```terraform apply```



