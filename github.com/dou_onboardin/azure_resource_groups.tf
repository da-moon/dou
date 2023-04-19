#####
# To remove
#####

module "resource_group_assoc" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.user_emails, "members"))
  location    = "South Central US"
}

####


# US Resource Groups
module "resource_groups_east_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.east_us, "members"))
  location    = "East US"
}

module "resource_groups_east_us_2" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.east_us_2, "members"))
  location    = "East US"
}

module "resource_groups_north_central_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.north_central_us, "members"))
  location    = "North Central US"
}

module "resource_groups_central_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.central_us, "members"))
  location    = "Central US"
}

module "resource_groups_south_central_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.south_central_us, "members"))
  location    = "South Central US"
}

module "resource_groups_west_central_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.west_central_us, "members"))
  location    = "West Central c"
}

module "resource_groups_west_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.west_us, "members"))
  location    = "West US"
}

module "resource_groups_west_us_2" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.west_us_2, "members"))
  location    = "West US 2"
}

# DOUniversity 2
module "resource_groups_douniversity_central_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.university_central_us, "members"))
  location    = "Central US"
}

module "resource_groups_douniversity_west_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.university_west_us, "members"))
  location    = "West US"
}

module "resource_groups_douniversity_east_us" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.university_east_us, "members"))
  location    = "East US"
}

# Canada Resource Groups

module "resource_groups_canada_east" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.canada_east, "members"))
  location    = "Canada East"
}

module "resource_groups_canada_central" {
  source      = "./modules/azure"
  user_emails = sort(lookup(var.canada_central, "members"))
  location    = "Canada Central"
}
