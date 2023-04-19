ami_name      = "eda-aws-ami"
instance_type = "t2.micro"
region        = "ca-central-1"
source_ami    = "ami-0277fbe7afa8a33a6"
ssh_username  = "ec2-user"
vpc_id        = "replace_with_your_vpi_id"
pub_subnet    = ["replace_with_your_public_subnet_id"]
role          = "replace_with_your_iam_role_id" 