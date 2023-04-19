# AWS Custom AMI

## Summary
Packer code to build a custom image 

## Usage

- Before you run the code, you need to have already deployed a vpc with a public subnet, make sure to create variables.pkr.hcl (see varfiles folder to fin and example - example.pkrvars.hcl) in 2-packer folder with the necessary values before you run packer build and the file fsx_openzfs_dns_name was created successfully in terraform_ouput folder (see varfiles folder to find an example - example_fsx_openzfs_dns_name).

You can update the following values in your-file.pkrvars.hcl:

- ami_name      = Name for the image that your going to create (optional)
- instance_type = Instance tyoe that packer will use to create the image (optional) 
- region        = region for store the custom image (default = "ca-central-1")
- source_ami    = Image base to build the custom image (make sure that your are using the ami_id according to your region)
- ssh_username = username that packer will use to make all the configuracion in the ami (optional

> Note: You can remplace manually the values for vpc_id, pub_subnet and role or run the commands below.

Run this command in the following path ./1-env:

```sh
echo -n "vpc_id=" >> ../2-packer/your-file.pkrvars.hcl && terraform output vpc_id >> ../2-packer/your-file.pkrvars.hcl

echo -n "pub_subnets=" >> ../2-packer/your-file.pkrvars.hcl && terraform output pub_subnets >> ../2-packer/your-file.pkrvars.hcl
  
echo -n "role=" >> ../2-packer/your-file.pkrvars.hcl && terraform output role-server >> ../2-packer/your-file.pkrvars.hcl
```

Those commands will set the next values in variables.pkrvars.hcl

- vpc_id
- pub_subnets
- role

## Run

```sh
packer init .
packer fmt .
packer validate .
packer build -var-file=variables.pkrvars.hcl .
```
