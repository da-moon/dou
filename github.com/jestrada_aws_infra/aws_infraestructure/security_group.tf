resource "aws_security_group" "allow_ssh" {
  name        = "${var.project_name}-allow_ssh"
  description = "Allow all inbound traffic to ssh"
  vpc_id      = aws_vpc.xportVPC.id

  ingress {
    #TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "allow_9043" {
  name        = "${var.project_name}-allow_9043"
  description = "Allow all inbound traffic to 9043"
  vpc_id      = aws_vpc.xportVPC.id

  ingress {
    #TLS (change to whatever ports you need)
    from_port = 9043
    to_port   = 9043
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "allow_http" {
  name        = "${var.project_name}-allow_http"
  description = "Allow all inbound traffic to http"
  vpc_id      = aws_vpc.xportVPC.id

  ingress {
    #TLS (change to whatever ports you need)
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

