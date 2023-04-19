
resource "aws_codebuild_project" "main" {
  for_each   = {
    for index, stage in var.build_stages:
    stage.stage_name => stage
  }
  name           = var.prefix_name != "" ? "${var.prefix_name}-${each.value["stage_name"]}" : each.value["stage_name"]
  description    = "Code build project for ${each.value["stage_name"]} stage"
  build_timeout  = "180"
  service_role   = aws_iam_role.service_role.arn
  source_version = "refs/heads/main"

  source {
    type      = var.repo_type
    location  = var.repo_url
    buildspec = each.value["build_spec"]
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = var.codebuild_image
    image_pull_credentials_type = "SERVICE_ROLE"
    privileged_mode             = false
    compute_type                = "BUILD_GENERAL1_SMALL"

    dynamic "environment_variable" {
      for_each = each.value["env_vars"]

      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }
}

