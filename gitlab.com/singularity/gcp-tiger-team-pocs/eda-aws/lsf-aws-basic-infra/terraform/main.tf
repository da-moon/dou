// resource "aws_key_pair" "example" {
//   key_name   = "example-key"
//   public_key = var.public_key
// }

// resource "aws_subnet" "subnet-lsf" {
//   vpc_id     = var.vpc_id
//   cidr_block = "172.31.0.0/16"//"10.10.10.0/24"

//   tags = {
//     Name = "subnet-lsf"
//   }
// }

// resource "aws_security_group" "example" {
//   name        = "securityGroupLSF"
//   description = "securityGroupLSF"
//   vpc_id      = var.vpc_id

//   // To Allow SSH Transport
//   ingress {
//     description = "To Allow SSH Transport"
//     from_port   = 22
//     to_port     = 22
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }


//   lifecycle {
//     create_before_destroy = true
//   }
// }


// resource "aws_instance" "example" {
//   ami                         = var.ami
//   instance_type               = var.vm_type
//   subnet_id                   = aws_subnet.subnet-lsf.id
//   associate_public_ip_address = true
//   key_name                    = aws_key_pair.example.key_name


//   vpc_security_group_ids = [
//     aws_security_group.example.id
//   ]
//   root_block_device {
//     delete_on_termination = true
//     //iops                  = 150
//     volume_size           = 50
//     //volume_type           = "gp2"
//   }
//   tags = {
//     Name        = var.vm_name
//     Environment = "DEV"
//     OS          = "rhel 8"
//     //Managed     = "IAC"
//   }

//   depends_on = [aws_security_group.example]
// }


// output "ec2instance" {
//   value = aws_instance.example.public_ip
// }