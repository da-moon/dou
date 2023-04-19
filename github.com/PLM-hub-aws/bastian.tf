# Generate SSH Key pair for connection to bastian host
# https://www.terraform.io/docs/providers/aws/r/key_pair.html
resource "tls_private_key" "ssh_key" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "keypair" {
  key_name      = "${var.project_name}-dev"
  public_key    = tls_private_key.ssh_key.public_key_openssh
  tags = {
    Project     = var.project_name
    Environment = var.run_env
  }
}

# Create local copy of the public ssh key for accessing the bastian host
# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "file" {
    content           = tls_private_key.ssh_key.private_key_pem
    filename          = "${path.module}/key_private.pem"
    file_permission   = "0600"
}

# EC2 Instance Config
# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "bastian" {
  key_name               = aws_key_pair.keypair.key_name
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  tags = {
    Project              = var.project_name
    Environment          = var.run_env
    Name                 = "${var.project_name}_key_bastian"
  }
}

