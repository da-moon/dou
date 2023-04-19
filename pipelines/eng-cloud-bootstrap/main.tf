terraform {
  backend "s3" {
    key = "tfstates/bootstrap"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.bootstrap_region
}

# List of environment names including the folder "teamcenter"
data "external" "tc_environments" {
  working_dir = path.module
  program     = ["sh", "detect_envs.sh"]
  query = {
    software = "teamcenter"
  }
}

locals {
  repo_name                 = var.installation_prefix != "" ? "${var.installation_prefix}-${var.vcs_reponame}" : var.vcs_reponame
  repo_type                 = var.vcs_provider == "codecommit" ? "CODECOMMIT" : ""
  tc_environments           = split(",", data.external.tc_environments.result["envs"])
  tc_environments_enabled   = toset(var.teamcenter_enabled ? local.tc_environments : [])
  bootstrap_pipeline_prefix = var.installation_prefix != "" ? "${var.installation_prefix}-eng-cloud-bootstrap" : "eng-cloud-bootstrap"
  tc_pipelines_prefix       = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
}

#---------------------------------------------- VCS section ----------------------------------------------
module "codecommit" {
  count     = var.vcs_provider == "codecommit" ? 1 : 0
  source    = "../../components/terraform/codecommit"
  repo_name = local.repo_name
  region    = var.bootstrap_region
}

#---------------------------------------------- CI/CD section ----------------------------------------------
module "codebuild_bootstrap" {
  source           = "../../components/terraform/codebuild"
  prefix_name      = local.bootstrap_pipeline_prefix
  repo_url         = module.codecommit[0].repo_https_url
  repo_type        = local.repo_type
  artifacts_bucket = var.bootstrap_bucket_name
  codebuild_image  = local.codebuild_image
  build_stages = [
    {
      "stage_name" = "deploy_pipelines",
      "build_spec" = "pipelines/eng-cloud-bootstrap/buildspec.yml",
      "env_vars"   = {}
    }
  ]
}

module "codepipeline_bootstrap" {
  source           = "../../components/terraform/codepipeline"
  repo_name        = local.repo_name
  pipeline_name    = local.bootstrap_pipeline_prefix
  artifacts_bucket = var.bootstrap_bucket_name
  build_stages = [
    {
      "name" = "DeployPipelines",
      "actions" = [
        {
          "name"     = "Deploy"
          "category" = "Build"
          "provider" = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.bootstrap_pipeline_prefix}-deploy_pipelines"
          }
          "run_order" = 1
        }
      ]
    }
  ]
}

module "codebuild_tc_shared" {
  count            = var.teamcenter_enabled ? 1 : 0
  source           = "../../components/terraform/codebuild"
  prefix_name      = "${local.tc_pipelines_prefix}-shared"
  repo_url         = module.codecommit[0].repo_https_url
  repo_type        = local.repo_type
  codebuild_image  = local.codebuild_image
  artifacts_bucket = var.bootstrap_bucket_name
  build_stages = [
    {
      "stage_name" = "deploy_shared_infra",
      "build_spec" = "pipelines/tc-shared/01_shared_infra/01_infra/buildspec.yml",
      "env_vars"   = {},
    },
    {
      "stage_name" = "bake_base_ami",
      "build_spec" = "pipelines/tc-shared/01_shared_infra/02_base_ami/buildspec.yml",
      "env_vars"   = {
        FORCE_REBAKE = false
      },
    },
    {
      "stage_name" = "deployment_center",
      "build_spec" = "pipelines/tc-shared/02_deployment_center/buildspec.yml",
      "env_vars"   = {
        FORCE_REBAKE = false
        DELETE_DATA  = false
      },
    }
  ]
}

module "codepipeline_tc_shared" {
  count            = var.teamcenter_enabled ? 1 : 0
  source           = "../../components/terraform/codepipeline"
  repo_name        = local.repo_name
  pipeline_name    = "${local.tc_pipelines_prefix}-shared"
  artifacts_bucket = var.bootstrap_bucket_name
  build_stages = [
    {
      "name" = "DeploySharedInfrastructure",
      "actions" = [
        {
          "name"     = "SharedInfrastructure"
          "category" = "Build"
          "provider" = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-shared-deploy_shared_infra"
          }     
          "run_order" = 1
        },
        {
          "name"     = "BakeBaseAMI"
          "category" = "Build"
          "provider" = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-shared-bake_base_ami"
          }     
          "run_order" = 2
        }
      ]
    },
    {
      "name" = "DeploymentCenter",
      "actions" = [
        {
          "name"     = "DeploymentCenter"
          "category" = "Build"
          "provider" = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-shared-deployment_center"
          }
          "run_order" = 1
        }
      ]
    }
  ]
}

module "codebuild_tc_app" {
  for_each         = local.tc_environments_enabled
  source           = "../../components/terraform/codebuild"
  prefix_name      = "${local.tc_pipelines_prefix}-${each.value}"
  repo_url         = module.codecommit[0].repo_https_url
  repo_type        = local.repo_type
  codebuild_image  = local.codebuild_image
  artifacts_bucket = var.bootstrap_bucket_name
  build_stages = [
     {
      "stage_name" = "init_env",
      "build_spec" = "pipelines/tc-app/02_init_env/01_base_infra/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value,
        FORCE_REINIT = false,
        DELETE_DATA  = false
      }
    }, 
    {
      "stage_name" = "build_server",
      "build_spec" = "pipelines/tc-app/02_init_env/02_build_server/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "fsc_master",
      "build_spec" = "pipelines/tc-app/03_fsc/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "corporate",
      "build_spec" = "pipelines/tc-app/04_corporate/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "bake_solr_indexing_image",
      "build_spec" = "pipelines/tc-app/05_solr_indexing/01_bake/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "deploy_solr_indexing_image",
      "build_spec" = "pipelines/tc-app/05_solr_indexing/02_deploy/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
      }
    },#webserver
        {
      "stage_name" = "bake_webserver_image",
      "build_spec" = "pipelines/tc-app/06_webserver/01_bake/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
      {
      "stage_name" = "deploy_webserver",
      "build_spec" = "pipelines/tc-app/06_webserver/02_deploy/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
      }
     },#enterprise server
     {
      "stage_name" = "enterprise_tier",
      "build_spec" = "pipelines/tc-app/05_enterprise_tier/buildspec.yml",
      "env_vars"   = {
        ENV_NAME     = each.value
        FORCE_REBAKE = false
      }
    },
       {
      "stage_name" = "deploy_enterprise_server",
      "build_spec" = "pipelines/tc-app/05_enterprise_server/02_deploy/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
      }
    },
    {
      "stage_name" = "generate_install_scripts",
      "build_spec" = "pipelines/tc-app/02_init_env/02_generate_install_scripts/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
        FORCE_REGENERATE = false
      }
    },
    {
      "stage_name" = "file_server",
      "build_spec" = "pipelines/tc-app/05_file_server/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "prepare_microservices",
      "build_spec" = "pipelines/tc-app/05_microservices/01_prepare/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "deploy_microservices",
      "build_spec" = "pipelines/tc-app/05_microservices/02_deploy/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
      }
    },
    {
      "stage_name" = "bake_aw_gateway",
      "build_spec" = "pipelines/tc-app/06_aw_gateway/01_bake/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
        FORCE_REBAKE = false
      }
    },
    {
      "stage_name" = "deploy_aw_gateway",
      "build_spec" = "pipelines/tc-app/06_aw_gateway/02_deploy/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
      }
    },
    {
      "stage_name" = "bake_aw_client_builder",
      "build_spec" = "pipelines/tc-app/07_aw_client_builder/01_bake/buildspec.yml",
      "env_vars"   = {
        ENV_NAME = each.value
        FORCE_REBAKE = false
      }
    }
  ]
}

module "codepipeline_tc_app" {
  for_each         = local.tc_environments_enabled
  source           = "../../components/terraform/codepipeline"
  repo_name        = local.repo_name
  pipeline_name    = "${local.tc_pipelines_prefix}-${each.value}"
  artifacts_bucket = var.bootstrap_bucket_name
  build_stages = [
    {
      "name" = "GenerateBOM",
      "actions" = [
        {
          "name"     = "GenerateBOM"
          "category" = "Invoke"
          "provider" = "Lambda"
          "configuration" = {
            "FunctionName"   = var.installation_prefix != "" ? "${var.installation_prefix}-tc-bom" : "tc-bom"
            "UserParameters" = "file_path=environments/teamcenter/${each.value}/quick_deploy_configuration.xml"
          }
          "run_order" = 1
        }
      ]
    },
    {
      "name"    = "InitEnv",
      "actions" = [
        {
          "name"          = "BaseInfra"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-init_env"
          },
          "run_order"     = 1
        },
        {
          "name"          = "GenerateInstallScripts"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-generate_install_scripts"
          }
          "run_order"     = 2
        },
        {
          "name"          = "BuildServer"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-build_server"
          }
          "run_order"     = 2
        }
      ]
    },
    {
      "name"    = "DeployTeamCenter",
      "actions" = [
        {
          "name"       = "FSCMaster"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-fsc_master"
          }
          "run_order"     = 1
        },
        {
          "name"       = "CorporateServer"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-corporate"
          }
          "run_order"     = 2
        },
        {
          "name"          = "EnterpriseTier"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-enterprise_tier"
          }
          "run_order"     = 3
        },
        {
          "name"          = "FileServer"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-file_server"
          }
          "run_order"     = 3
        },
        {
          "name"          = "PrepareMicroservices"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-prepare_microservices"
          }
          "run_order"     = 3
        },
        {
          "name"          = "BakeSolrIndexingImage"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-bake_solr_indexing_image"
          }
          "run_order"     = 3
        },
        {
          "name"          = "DeployMicroservices"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-deploy_microservices"
          }
          "run_order"     = 4
        }, 
        {
          "name"          = "DeploySolrIndexingImage"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-deploy_solr_indexing_image"
          }
          "run_order"     = 4
        },
        {
          "name"          = "BakeAWGateway"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-bake_aw_gateway"
          }
          "run_order"     = 5
        },
        {
          "name"          = "BakeWebServer"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-bake_webserver_image"
          }
          "run_order"     = 5
        },
        {
          "name"          = "DeployAWGateway"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-deploy_aw_gateway"
          }
          "run_order"     = 6
        },
        {
          "name"          = "DeployWebServer"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-deploy_webserver"
          }
          "run_order"     = 6
        },
        {
          "name"          = "BakeAWClientBuilder"
          "category"      = "Build"
          "provider"      = "CodeBuild"
          "configuration" = {
            ProjectName = "${local.tc_pipelines_prefix}-${each.value}-bake_aw_client_builder"
          }
          "run_order"     = 7
        }
      ]
    }
  ]
}

data "archive_file" "lambda_bom" {
  count       = var.teamcenter_enabled == true ? 1 : 0
  type        = "zip"
  source_file = "${path.module}/../tc-app/01_bom/quick_deploy_parser.py"
  output_path = "lambda.zip"
}

module "lambda_bom" {
  count            = var.teamcenter_enabled == true ? 1 : 0
  source           = "../../components/terraform/lambda"
  function_name    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-bom" : "tc-bom"
  code             = "${path.cwd}/lambda.zip"
  code_hash        = data.archive_file.lambda_bom[0].output_base64sha256
  pipeline_name    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-bom" : "tc-bom"
  artifacts_bucket = var.bootstrap_bucket_name
  handler          = "quick_deploy_parser.lambda_handler"

  env_vars = {
    "INPUT_SOURCE" = "code_pipeline",
    "OUTPUT_DESTINATION" = "ssm",
  }
}

resource "aws_ssm_parameter" "vcs_repo_type" {
  name           = "/teamcenter/shared/vcs/type"
  type           = "String"
  insecure_value = var.vcs_provider
  overwrite      = true
}

resource "aws_ssm_parameter" "vcs_repo_name" {
  name           = "/teamcenter/shared/vcs/clone_https_url"
  type           = "String"
  insecure_value = module.codecommit[0].repo_https_url
  overwrite      = true
}

resource "aws_ssm_parameter" "environments" {
  name           = "/teamcenter/shared/env_names"
  type           = "StringList"
  insecure_value = join(",", local.tc_environments_enabled)
  overwrite      = true
}


