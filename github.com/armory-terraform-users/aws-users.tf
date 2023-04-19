locals {
  # get json
  developers_data = jsondecode(file("${path.module}/developers.json"))
  admins_data     = jsondecode(file("${path.module}/admins.json"))

  # get all users
  developers_usernames = [for user in local.developers_data.developers : user.user_name]
  developers           = local.developers_data.developers

  admins_usernames = [for user in local.admins_data.admins : user.user_name]
  admins           = local.admins_data.admins

  all_users     = concat(local.developers, local.admins)
  all_usernames = toset([for user in local.all_users : user.user_name])
}

module "users" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  for_each = local.all_usernames
  name     = each.value

  create_iam_user_login_profile = true
  create_iam_access_key         = false
  force_destroy                 = true
  password_reset_required       = true
  password_length               = 10
  pgp_key                       = "keybase:angel_cruz_tm"
}

module "iam_group_developers" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "developers"

  group_users = concat(local.developers_usernames, local.admins_usernames)

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]

  depends_on = [module.users]
}

module "iam_group_admins" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "admins"

  group_users = local.admins_usernames

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  depends_on = [module.users]
}
