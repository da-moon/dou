# EC2 Instance module

<!-- BEGIN_TF_DOCS -->

#### Considerations
Master and Workers are in private subnet so we are using a Bastion host to login trough ssh

#### Steps
1. ssh-add ~/.ssh/your-key
2. ssh -A -i ~/.ssh/your-key your-user@bastion-public-ip # This will login to the bastion in public subnet
3. ssh your-user@master/worker-private-ip # From the bastion this will login to the master or worker in private subnet


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |

## Inputs
Note: Variables that are marked as not required will take the default value.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The ami to use for deploying vm | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment in which you will deploy th ec2 | `string` | `""` | no |
| <a name="input_fsx_dns"></a> [fsx\_dns](#input\_fsx\_dns) | DNS name | `string` | `""` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM role to attach | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | key name for aws key pair resource to use in the ec2 | `string` | `"eda_aws_key"` | no |
| <a name="input_os"></a> [os](#input\_os) | OS your are using in the ec2 | `string` | `""` | no |
| <a name="input_priv_key"></a> [priv\_key](#input\_priv\_key) | private key to connect to ec2 | `string` | `""` | no |
| <a name="input_priv_subnet_id"></a> [priv\_subnet\_id](#input\_priv\_subnet\_id) | The VPC Subnet ID to launch in | `string` | `null` | no |
| <a name="input_pub_subnet_id"></a> [pub\_subnet\_id](#input\_pub\_subnet\_id) | The VPC Subnet ID to launch in | `string` | `null` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Public key for ssh to be copied to ec2 | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region used to build all objects | `string` | `""` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | security group of the ec2 instance | `string` | `""` | no |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | Source path for user data script. This path should contain only until generic file with no extension since in the module it will append \_rol.sh | `string` | `""` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | source path for requeriments installation script | `string` | `""` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | name for aws instance resource | `string` | `"eda"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | n/a |
| <a name="output_master_private_ip"></a> [master\_private\_ip](#output\_master\_private\_ip) | n/a |
| <a name="output_workers_private_ip"></a> [workers\_private\_ip](#output\_workers\_private\_ip) | n/a |
<!-- END_TF_DOCS -->