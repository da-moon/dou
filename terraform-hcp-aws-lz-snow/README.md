# hcp-vault-aws-networking

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_security_group.default_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.ec2_tfc_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.vpc_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_main_route_table_association.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_ram_resource_association.ram_asc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.ram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route_table.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.main_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.tfc_isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.main_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | Variable used for looking up the AMI for images within AWS based on name and the owner ID | `map(string)` | <pre>{<br>  "name": "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*",<br>  "owners": "099720109477"<br>}</pre> | no |
| <a name="input_aws_hcp_tfc_ec2_name"></a> [aws\_hcp\_tfc\_ec2\_name](#input\_aws\_hcp\_tfc\_ec2\_name) | Name of the EC2 instance that will run the TFC agent | `string` | `"hcp-vault-tfc-agent"` | no |
| <a name="input_aws_hcp_tgw_ram_name"></a> [aws\_hcp\_tgw\_ram\_name](#input\_aws\_hcp\_tgw\_ram\_name) | Name of the AWS RAM that will be created to allow resource sharing between accounts | `string` | `"hcp-ram"` | no |
| <a name="input_aws_nat_subnet"></a> [aws\_nat\_subnet](#input\_aws\_nat\_subnet) | CIDR block for the AWS NAT Gateway. Should be allocated from the VPC subnet range. | `string` | `"10.0.3.0/24"` | no |
| <a name="input_aws_tag_environment"></a> [aws\_tag\_environment](#input\_aws\_tag\_environment) | Tag that will be applied to all AWS resources | `string` | `"hcp"` | no |
| <a name="input_aws_tag_owner"></a> [aws\_tag\_owner](#input\_aws\_tag\_owner) | Your email - This tag that will be appled to all AWS resources. | `string` | n/a | yes |
| <a name="input_aws_tag_service"></a> [aws\_tag\_service](#input\_aws\_tag\_service) | Name of the service that this environment is supporting | `string` | `"vault"` | no |
| <a name="input_aws_tag_ttl"></a> [aws\_tag\_ttl](#input\_aws\_tag\_ttl) | TTL of the resources that will be provisioned for this demo. Specified in hours. | `number` | `24` | no |
| <a name="input_aws_tfc_agent_subnet"></a> [aws\_tfc\_agent\_subnet](#input\_aws\_tfc\_agent\_subnet) | CIDR block for TFC Agent workloads. Should be allocated from the VPC subnet range. | `string` | `"10.0.2.0/24"` | no |
| <a name="input_aws_tfc_sg_desc"></a> [aws\_tfc\_sg\_desc](#input\_aws\_tfc\_sg\_desc) | Description for the Security Group that will be created for TFC Agent workloads. | `string` | `"Security Group for the TFCB Agent workloads"` | no |
| <a name="input_aws_tfc_sg_name"></a> [aws\_tfc\_sg\_name](#input\_aws\_tfc\_sg\_name) | Name of the Security Group that will be created for TFC Agent workloads. | `string` | `"hcp-tfc-agent-sg"` | no |
| <a name="input_aws_tgw_bgp_asn"></a> [aws\_tgw\_bgp\_asn](#input\_aws\_tgw\_bgp\_asn) | BGP ASN that will be configured on the AWS Transit Gateway. Defaults to 64512 | `number` | `64512` | no |
| <a name="input_aws_vault_sg_desc"></a> [aws\_vault\_sg\_desc](#input\_aws\_vault\_sg\_desc) | Description for the AWS Security Group that will be created to allow access to Vault | `string` | `"Security Group that allows access to HCP Vault"` | no |
| <a name="input_aws_vault_sg_name"></a> [aws\_vault\_sg\_name](#input\_aws\_vault\_sg\_name) | AWS Security Group name that will be set on the security group | `string` | `"hcp-vault-sg"` | no |
| <a name="input_aws_vpc_cidr_block"></a> [aws\_vpc\_cidr\_block](#input\_aws\_vpc\_cidr\_block) | CIDR block for the AWS VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_hvn_cidr_block"></a> [hvn\_cidr\_block](#input\_hvn\_cidr\_block) | CIDR block for the HashiCorp Virtual Network VPC in HCP | `string` | `"172.25.16.0/20"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the EC2 instance that will be deployed. Defaults to t2.micro | `string` | `"t2.medium"` | no |
| <a name="input_tfc_agent_name"></a> [tfc\_agent\_name](#input\_tfc\_agent\_name) | Name that will be applied to the TFC agent inside of the EC2 instace | `string` | `"aws-ec2-tfcb-agent"` | no |
| <a name="input_tfc_agent_token"></a> [tfc\_agent\_token](#input\_tfc\_agent\_token) | Token that will be used inside of the EC2 instance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main_subnet"></a> [main\_subnet](#output\_main\_subnet) | ID for the main subnet that was provisioned |
| <a name="output_resource_share_arn"></a> [resource\_share\_arn](#output\_resource\_share\_arn) | Resource Share ARN that was generated |
| <a name="output_tfc_agent_sg"></a> [tfc\_agent\_sg](#output\_tfc\_agent\_sg) | ID for the TFC Agent Security Group |
| <a name="output_transit_gw"></a> [transit\_gw](#output\_transit\_gw) | Transit Gateway ID |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | CIDR Block of the main VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
