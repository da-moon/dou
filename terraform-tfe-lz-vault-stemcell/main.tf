locals {
  vcs_repo             = "DigitalOnUs/terraform-snow-lz-vault"
  var_set_wait         = "15s"
  vcs_branch           = ""
  hcp_workspace_agents = true
}



module "terraform-hcp-aws-lz-snow" {
  source                  = "app.terraform.io/DoU-TFE/onboarding-module/tfe"
  version                 = ">=0.0.1"
  workspace_name          = "01-terraform-snow-aws-networking"
  workspace_description   = "Workspace that creates required networking configuration and TFCB agents in AWS for TFC agents and HCP Vault."
  organization            = var.tfc_organization
  workspace_tags          = ["aws", "networking", "agents", "aws-credentials"]
  workspace_vcs_directory = "terraform-hcp-aws-lz-snow"
  vcs_repo = {
    identifier     = local.vcs_repo
    branch         = local.vcs_branch
    oauth_token_id = var.oauth_token_id
  }
  variables = {
    tfc_agent_token = {
      category    = "terraform"
      description = "(Required) TFC agent token used by the agent container for TFCB"
      sensitive   = true
      value       = tfe_agent_token.ec2_tfcb_agents.token
    }
  }
}

module "terraform-snow-hcp-vault" {
  source                  = "app.terraform.io/DoU-TFE/onboarding-module/tfe"
  version                 = ">=0.0.1"
  workspace_name          = "02-hc-hcp-vault-init"
  workspace_description   = "Workspace that creates the HCP Vault cluster"
  organization            = var.tfc_organization
  workspace_tags          = ["hcp", "aws", "vault", "tfc", "hcp-credentials", "aws-credentials", "networking"]
  workspace_vcs_directory = "terraform-hcp-vault-init"
  vcs_repo = {
    identifier     = local.vcs_repo
    oauth_token_id = var.oauth_token_id
    branch         = local.vcs_branch
  }
  variables = {
    tfc_vault_admin_workspace = {
      category    = "terraform"
      description = "(Required) Name of the Workspace where the root token will be pushed for the initial configuration"
      sensitive   = false
      value       = module.hcp-vault-admin-workspace.workspace_name
    },
    tfc_aws_networking_workspace = {
      category    = "terraform"
      description = "(Required) Name of the Workspace where the AWS networking configuration has been generated"
      sensitive   = false
      value       = module.terraform-hcp-aws-lz-snow.workspace_name
    },
    hcp_region = {
      category    = "terraform"
      description = "(Required) Region where the HCP Vault cluster will be deployed"
      sensitive   = true
      value       = var.hcp_region
    },
  }
}

module "hcp-vault-admin-workspace" {
  source                  = "app.terraform.io/DoU-TFE/onboarding-module/tfe"
  version                 = ">=0.0.1"
  workspace_name          = "03-hc-hcp-vault-admin-ns"
  workspace_description   = "Workspace that configures the admin namespace"
  organization            = var.tfc_organization
  workspace_agents        = local.hcp_workspace_agents
  agent_pool_name         = tfe_agent_pool.ec2_tfcb_agents.name
  workspace_tags          = ["hcp", "vault", "tfc"]
  workspace_vcs_directory = "terraform-hcp-admin-ns"
  vcs_repo = {
    identifier     = local.vcs_repo
    oauth_token_id = var.oauth_token_id
    branch         = local.vcs_branch
  }
  variables = {
    tfc_target_workspace = {
      category    = "terraform"
      description = "(Required) Workspace where the Admin Approle role_id and secret_id will be pushed"
      sensitive   = false
      value       = module.hcp-vault-nsaas-workspace.workspace_name
    }
  }
  depends_on = [
    tfe_agent_pool.ec2_tfcb_agents
  ]
}

module "hcp-vault-nsaas-workspace" {
  source                  = "app.terraform.io/DoU-TFE/onboarding-module/tfe"
  version                 = ">=0.0.1"
  workspace_name          = "04-hc-hcp-vault-nsaas"
  workspace_description   = "Workspace that creates tenant namespaces"
  organization            = var.tfc_organization
  workspace_agents        = local.hcp_workspace_agents
  agent_pool_name         = var.tfc_ec2_agent_name
  workspace_tags          = ["hcp", "vault", "tfc"]
  workspace_vcs_directory = "terraform-hcp-vault-nsaas"
  vcs_repo = {
    identifier     = local.vcs_repo
    branch         = local.vcs_branch
    oauth_token_id = var.oauth_token_id
  }
  variables = {
    tfc_vault_workspace = {
      category    = "terraform"
      description = "(Required) Workspace where the role_id and secret_id output will be pushed"
      sensitive   = false
      value       = module.hcp-vault-tenant-workspace.workspace_name
    }
  }
}

module "hcp-vault-tenant-workspace" {
  source                  = "app.terraform.io/DoU-TFE/onboarding-module/tfe"
  version                 = ">=0.0.1"
  workspace_name          = "05-hc-hcp-vault-tenant"
  workspace_description   = "Workspace for the HCP Vault Tenant Namespace"
  organization            = var.tfc_organization
  workspace_agents        = local.hcp_workspace_agents
  agent_pool_name         = var.tfc_ec2_agent_name
  workspace_tags          = ["hcp", "vault", "tfc"]
  workspace_vcs_directory = "terraform-hcp-vault-snow-ns"
  vcs_repo = {
    identifier     = local.vcs_repo
    oauth_token_id = var.oauth_token_id
    branch         = local.vcs_branch
  }
  variables = {
    tfc_approle_workspaces = {
      category    = "terraform"
      description = "(Required) Workspaces where the role_id and secret_id output will be pushed"
      sensitive   = false
      value       = ""
    },
  }
}

resource "tfe_team" "hcp" {
  name         = var.tfc_team_name
  organization = var.tfc_organization
  visibility   = "organization"
  organization_access {
    manage_workspaces = true
  }
}

resource "tfe_team_token" "hcp_team_token" {
  team_id = tfe_team.hcp.id
}

resource "tfe_agent_pool" "ec2_tfcb_agents" {
  name         = var.tfc_ec2_agent_name
  organization = var.tfc_organization
}

resource "tfe_agent_token" "ec2_tfcb_agents" {
  agent_pool_id = tfe_agent_pool.ec2_tfcb_agents.id
  description   = var.tfc_ec2_agent_description
}

module "aws_general" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = "0.0.7"
  organization        = var.tfc_organization
  create_variable_set = true
  create_duration     = local.var_set_wait
  variable_set_name   = "aws-general"
  tags                = ["aws"]
  variables = {
    AWS_REGION = {
      category    = "env"
      description = "(Required) AWS Region where the resources will be instantiated."
      sensitive   = false
      hcl         = false
      value       = "us-west-2"
    },
    aws_tag_owner = {
      category    = "terraform"
      description = "(Required) Owner of all resources that will be created - Use an email address"
      sensitive   = false
      hcl         = false
      value       = "wwfo-se-amer-innovationlab@hashicorp.com"
    },
    aws_tag_ttl = {
      category    = "terraform"
      description = "(Required) TTL of the resources that will be provisioned for this demo. Specified in hours"
      sensitive   = false
      hcl         = false
      value       = "8760"
    },
  }
}

module "aws_credentials" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = "0.0.7"
  organization        = var.tfc_organization
  create_variable_set = true
  create_duration     = local.var_set_wait
  variable_set_name   = "aws-credentials"
  tags                = ["aws-credentials"]
  variables = {
    AWS_ACCESS_KEY_ID = {
      category    = "env"
      description = "(Required) AWS Access Key that will be used for authentication."
      sensitive   = true
      hcl         = false
      value       = var.aws_access_key
    },
    AWS_SECRET_ACCESS_KEY = {
      category    = "env"
      description = "(Required) AWS Secret Access Key that will be used for authentication"
      sensitive   = true
      hcl         = false
      value       = var.aws_secret_key
    },
  }
}

module "tfc_general" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = "0.0.7"
  organization        = var.tfc_organization
  create_variable_set = true
  create_duration     = local.var_set_wait
  variable_set_name   = "tfc-general"
  tags                = ["tfc"]
  variables = {
    tfc_organization = {
      category    = "terraform"
      description = "(Required) Name of the TFC Organization where the workspaces reside"
      sensitive   = false
      hcl         = false
      value       = var.tfc_organization
    },
    TFE_TOKEN = {
      category    = "env"
      description = "(Required) Token used to retrieve outputs from other workspaces"
      sensitive   = true
      hcl         = false
      value       = tfe_team_token.hcp_team_token.token
    },
  }
}

module "hcp_credentials" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = "0.0.7"
  organization        = var.tfc_organization
  create_variable_set = true
  create_duration     = local.var_set_wait
  variable_set_name   = "hcp-credentials"
  tags                = ["hcp-credentials"]
  variables = {
    HCP_CLIENT_ID = {
      category    = "env"
      description = "(Required) Password used to connect and authenticate with HashiCorp Cloud Platform"
      sensitive   = true
      hcl         = false
      value       = var.hcp_client_id
    },
    HCP_CLIENT_SECRET = {
      category    = "env"
      description = "(Required) Username used to connect and authenticate with HashiCorp Cloud Platform"
      sensitive   = true
      hcl         = false
      value       = var.hcp_secret_id
    },
  }
}

module "cloud_networking" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = "0.0.7"
  organization        = var.tfc_organization
  create_variable_set = true
  create_duration     = local.var_set_wait
  variable_set_name   = "cloud-networking"
  tags                = ["networking"]
  variables = {
    hvn_cidr_block = {
      category    = "terraform"
      description = "(Required) HVN CIDR Block that will be used inside of HCP"
      sensitive   = false
      hcl         = false
      value       = "172.25.16.0/20"
    },
    aws_vpc_cidr_block = {
      category    = "terraform"
      description = "(Required) AWS CIDR Block that will be used in the VPC"
      sensitive   = false
      hcl         = false
      value       = "10.200.0.0/16"
    },
    aws_tfc_agent_subnet = {
      category    = "terraform"
      description = "(Required) AWS CIDR Block for TFC Agents running in EC2 instances"
      sensitive   = false
      hcl         = false
      value       = "10.200.1.0/24"
    },
    aws_nat_subnet = {
      category    = "terraform"
      description = "(Required) AWS CIDR Block for AWS NAT Gateways"
      sensitive   = false
      hcl         = false
      value       = "10.200.2.0/24"
    },
  }
}
