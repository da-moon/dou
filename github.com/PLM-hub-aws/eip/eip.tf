#Create elastic ip
 resource "aws_eip" "licenseip" {
  vpc   = true
  tags = {
    Name        = "teamcenter-eip"
  }
 }

