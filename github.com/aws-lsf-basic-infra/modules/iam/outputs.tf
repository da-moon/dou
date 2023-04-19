# output "name" {
#   description = "The name of the policy"
#   value       = try(aws_iam_role_policy.ec2-role-policy.name, "")
# }

# output "arn" {
#   description = "The ARN assigned by AWS to this policy"
#   value       = try(aws_iam_role_policy.ec2-role-policy.arn, "")
# }

output "id-master" {
  value = aws_iam_instance_profile.eda-ec2-role-master.id
}

output "arn-master" {
  value = aws_iam_instance_profile.eda-ec2-role-master.arn
}

output "name-master" {
  value = aws_iam_instance_profile.eda-ec2-role-master.name
}

output "role-master" {
  value = aws_iam_instance_profile.eda-ec2-role-master.role
}

output "id-server" {
  value = aws_iam_instance_profile.eda-ec2-role-server.id
}

output "arn-server" {
  value = aws_iam_instance_profile.eda-ec2-role-server.arn
}

output "name-server" {
  value = aws_iam_instance_profile.eda-ec2-role-server.name
}

output "role-server" {
  value = aws_iam_instance_profile.eda-ec2-role-server.role
}