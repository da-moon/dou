terraform {
  required_version = ">= 0.13.3"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "myInstance" {
  ami           = "ami-0ec9faf93ed51c4e0"
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  apt-get update
                  apt-get --assume-yes install apache2
                  echo "<p> My Instance! </p>" > /var/www/html/index.html
                  ufw allow 'Apache'
                  systemctl enable apache2
                  systemctl start apache2
                  EOF
  
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.example.id]
  tags = {
        Name = "${var.prefix}-VM"
  }
}

resource "aws_security_group" "example" {
  name = "${var.prefix}-SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}