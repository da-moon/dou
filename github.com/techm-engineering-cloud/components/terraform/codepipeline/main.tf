
resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = var.artifacts_bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.repo_name
        BranchName           = "main"
        PollForSourceChanges = var.polling_enabled
      }
    }
  }

  dynamic "stage" {
    for_each = var.build_stages

    content {
      name = stage.value["name"]

      dynamic "action" {
        for_each = stage.value["actions"]

        content {
          name             = action.value["name"]
          category         = action.value["category"]
          owner            = "AWS"
          provider         = action.value["provider"]
          input_artifacts  = ["source_output"]
          output_artifacts = []
          version          = "1"
          run_order        = action.value["run_order"]
          configuration    = action.value["configuration"]
        }
      }
    }
  }

}

