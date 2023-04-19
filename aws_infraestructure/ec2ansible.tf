
resource "aws_instance" "ansible_host" {
  ami           = "ami-00eb20669e0990cb4"
  instance_type = var.instance_type
  key_name      = aws_key_pair.mykey.key_name
  subnet_id     = aws_subnet.xport-subnet-public-1.id
  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_9043.id}",
    "${aws_security_group.allow_http.id}"

  ]
  tags = {
    Name = "${var.project_name}-ansoble-instance"
  }
}
