Load balanced webserver example
===============================

This is a sample project that shows how to spin up a simple (blue-green)load balancer infraestructure on AWS.
 
## Summary of the infraestructure
* A VPC 10.0.0.0/16 CIDR with 10.0.1.0/24 private and 10.0.2.0/24 public subnets.
* 2 EC2 instances with nginx.
* Route53 cname(optional)

## Modules used:
* https://github.com/terraform-aws-modules/terraform-aws-vpc

## Prerequisites

This two environment variables are needed:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

## Variables to define

* private\_key_path="Path/to/your/ssh/key"
* key_name="YourSSHKeyName"
* route53\_zone_id="ZoneID"(optional)
* domain_name="domain.name"(optional)
* personal_dns=true(turn true for using route53 feature)

See it in action:
-----------------
Download aws provider and vpc module


    terraform init

Verify infraestructure to be created/updated/deleted


    terraform plan --var-file varsfile.tfvars

Apply the infraestructure defined


    terraform apply --var-file varsfile.tfvars

This will output the domain name of the elastic load balancer.


You can destroy all the infraestructure with

    terraform destroy --var-file varsfile.tfvars
