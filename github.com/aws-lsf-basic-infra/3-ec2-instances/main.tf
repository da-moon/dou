data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = var.backend_bucket
    key    = "env/terraform.tfstate"
    region = var.region
  }
}

module "ec2-instances" {
  source                       = "../modules/ec2-instance"
  key_name                     = var.key_name
  public_key                   = var.public_key
  priv_key                     = var.priv_key
  ami                          = var.ami
  priv_subnet_id               = data.terraform_remote_state.remote.outputs.priv_subnets[0]
  pub_subnet_id                = data.terraform_remote_state.remote.outputs.pub_subnets[0]
  security_group               = data.terraform_remote_state.remote.outputs.security_group_id
  fsx_dns                      = data.terraform_remote_state.remote.outputs.file_system_dns_name
  iam_instance_profile_master  = data.terraform_remote_state.remote.outputs.name-master
  iam_instance_profile_server  = data.terraform_remote_state.remote.outputs.name-server
  source_path                  = var.source_path
  region                       = var.region
  vm_name                      = var.vm_name
}
