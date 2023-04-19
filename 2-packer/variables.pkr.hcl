variable "ami_name" {
  type        = string
  description = "name for the ami"
  default     = "eda-aws-ami"
}
variable "vpc_id" {
  type        = string
  description = "vpc id in which the ami will build"
  default     = ""
}
variable "pub_subnets" {
  type        = tuple([string])
  description = "subnet in which the ami will build"
  default     = [""]
}
variable "instance_type" {
  type        = string
  description = "instance that packer will use to build the image"
  default     = "t2.micro"
}
variable "region" {
  type        = string
  description = "region in which ami will be stored"
  default     = "ca-central-1"
}
variable "source_ami" {
  type        = string
  description = "ami base to build the custom image"
  default     = "ami-0277fbe7afa8a33a6"
}
variable "role" {
  type        = string
  description = "iam instance profile to grant the enough permission in this case to download files from a s3 bucket"
  default     = ""
}
variable "ssh_username" {
  type        = string
  description = "username name that packer will use to do all the configuration that we want in the image"
  default     = "ec2-user"
}
variable "ami_user" {
  type        = tuple([string])
  description = "Allowed users  to download the ami"
  default     = ["237889007525"]
}

