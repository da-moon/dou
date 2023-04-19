region   = "us-west-1"
azs      = ["us-west-1a"]
vpc_name = "ibm-lsf-vpc"
cidr     = "10.0.0.0/16"
gateway  = true
pub_sub  = ["10.0.101.0/24"]
priv_sub = ["10.0.1.0/24", "10.0.2.0/24"]