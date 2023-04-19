resource "aws_security_group" "example" {
  name        = var.security_group_name
  description = "securityGroupLSF"
  vpc_id      = var.vpc_id

  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  // To Allow SSH Transport
  ingress {
    description = "To Allow SSH Transport"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "icmp" {
  description       = "Open port for icmp"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  self              = true
  security_group_id = aws_security_group.example.id
}
//AWS S3 ports
resource "aws_security_group_rule" "HTTP" {
  description       = "AWS S3 HTTP"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "HTTPS" {
  description       = "AWS S3 HTTPS"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
 // Ego ports
resource "aws_security_group_rule" "EGO" {
  description       = "EGO Ports"
  type              = "ingress"
  from_port         = 7869
  to_port           = 7872
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
//LSF Resource connector ports
resource "aws_security_group_rule" "LSF_REST_PORT_udp" {
  description = "LSF_REST_PORT"
  type              = "ingress"
  from_port         = 7869
  to_port           = 7869
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "LSF_REST_PORT" {
  description = "LSF_REST_PORT"
  type              = "ingress"
  from_port         = 6878
  to_port           = 6878
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "LSB_MDB_PORT_and_LSB_SBD_PORT" {
  description = "LSB_MDB_PORT and LSB_SBD_PORT"
  type              = "ingress"
  from_port         = 6881
  to_port           = 6883
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
// FSX Ports
resource "aws_security_group_rule" "NFS" {
  description = "Remote procedure call for NFS"
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "NFS2" {
  description = "Remote procedure call for NFS"
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "NFS_daemon" {
  description = "NFS server daemon"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "NFS_daemon_udp" {
  description = "NFS server daemon"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.example.id
}
resource "aws_security_group_rule" "FNS_mount" {
  description = "NFS mount, status monitor, and lock daemon"
  type              = "ingress"
  from_port         = 20001
  to_port           = 20003
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.example.id
}
//   # Enable mbd query child
resource "aws_security_group_rule" "LSB_QUERY_PORT" {
  description = "LSB_QUERY_PORT"
  type              = "ingress"
  from_port         = 6891
  to_port           = 6891
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "NIS_PORT_TCP" {
  description = "NIS_PORTS"
  type              = "ingress"
  from_port         = 955
  to_port           = 957
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "NIS_PORT_UDP" {
  description = "NIS_PORTS"
  type              = "ingress"
  from_port         = 955
  to_port           = 957
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.example.id
}