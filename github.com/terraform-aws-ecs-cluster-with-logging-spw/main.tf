data "aws_caller_identity" "current" {
}

data "aws_ami" "amazn_ami" {

   owners = ["amazon"]
   filter {
      name = "is-public"
      values = ["true"]
   }
   filter {
      name = "name"
      values = ["amzn-ami-2018.03*"]
   }
   filter {
      name = "architecture"
      values = ["x86_64"]
   }
   most_recent = true
}