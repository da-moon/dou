resource "aws_instance" "buildserver" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = split(",", var.vpc_security_group_ids)
  subnet_id              = var.subnet_id
 # iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name         = var.instance_name
  }
}
