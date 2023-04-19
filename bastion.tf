
resource "aws_instance" "bastion_host" {
  instance_type               = "t3.small"
  ami                         = var.ami_id_bastion
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  user_data                   = file("ebs_mount.sh")

  tags = {
    Name  = "german-bastion"
    Owner = "german"
  }
}

resource "aws_ebs_volume" "bastion_volume" {
  availability_zone = "us-west-2a"
  size              = 100
  type              = "gp3"

  tags = {
    Owner = "german"
  }
}

resource "aws_volume_attachment" "vol_att" {
  device_name = "/dev/sdz"
  volume_id   = aws_ebs_volume.bastion_volume.id
  instance_id = aws_instance.bastion_host.id
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "german-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("./german-key.pem")
  file_permission = "400"
  content = tls_private_key.bastion_key.private_key_pem
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Owner = "german"
    Name  = "allow-ssh"
  }
}

