output "user_passwords" {
  value = tomap({
    for k, user in module.users : user.iam_user_name => user.iam_user_login_profile_encrypted_password
  })
}
