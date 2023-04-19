
#==========  VPC  ===================#
vpc_name = "ibm-lsf-vpc"
region   = "eu-west-1"
azs      = ["eu-west-1a"]
cidr     = "10.0.0.0/16"
gateway  = true
pub_sub  = ["10.0.101.0/24"]
priv_sub = ["10.0.1.0/24", "10.0.2.0/24"]


#==========  S3 Bucket  ===================#
create = true
bucket = "eda-logs-juan"
acl    = "public-read"

#==========  FSX  ===================#
fsx_name            = "EDA file system"
storage_capacity    = 1024
throughput_capacity = 64

#==========  IAM  ===================#
iam_role             = "eda-ec2-role-juan"
iam_instance_profile = "eda-ec2-role-juan"
iam_role_policy      = "eda-ec2-role-policy-juan"

#==========  Security Group  ===================#
security_group_name = "securityGroupLSF"
