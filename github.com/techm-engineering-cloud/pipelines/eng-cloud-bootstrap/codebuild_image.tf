
locals {
  dockerfile_sha  = filesha1("Dockerfile")
  cb_repo_name    = "techm/engcloud/codebuild"
  codebuild_image = "${aws_ecr_repository.codebuild_image.repository_url}:${data.aws_ecr_image.codebuild_image.image_tag}"
}

data "aws_ecr_image" "codebuild_image" {
  depends_on      = [null_resource.generate_codebuild_image]
  repository_name = local.cb_repo_name
  image_tag       = "latest"
}

resource "aws_ecr_repository" "codebuild_image" {
  name                 = local.cb_repo_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_codebuild_project" "codebuild_image" {
  name           = var.installation_prefix != "" ? "${var.installation_prefix}-tc-codebuild-image" : "tc-codebuild-image"
  description    = "Code build project to build a docker image used by all the other codebuild projects in teamcenter pipelines."
  build_timeout  = "180"
  service_role   = aws_iam_role.service_role.arn
  source_version = "refs/heads/main"

  source {
    type      = local.repo_type
    location  = module.codecommit[0].repo_https_url
    buildspec = "pipelines/eng-cloud-bootstrap/buildspec_codebuildimage.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"

    environment_variable {
      name  = "ECR_REPO"
      value = aws_ecr_repository.codebuild_image.repository_url
    }

    environment_variable {
      name  = "REGION"
      value = var.bootstrap_region
    }

    environment_variable {
      name  = "SHA"
      value = local.dockerfile_sha
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }
}

resource "aws_iam_role" "service_role" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-codebuild-image-servicerole" : "codebuild-image-servicerole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["codebuild.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    tag-key = var.installation_prefix != "" ? "${var.installation_prefix}-codebuild-image-servicerole" : "codebuild-image-servicerole"
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-codebuild-image-policy" : "codebuild-image-policy"
  role = aws_iam_role.service_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "ecr:*",
        "secretsmanager:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_codecommit" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "null_resource" "generate_codebuild_image" {
  depends_on = [aws_codebuild_project.codebuild_image]

  triggers = {
    sha = local.dockerfile_sha
  }
  
  provisioner "local-exec" {
    command = <<EOF
BUILD_ID=$(aws --region ${var.bootstrap_region} codebuild start-build --project-name ${aws_codebuild_project.codebuild_image.name} | jq -r '.build.id')
while [ "$(aws codebuild batch-get-builds --ids $BUILD_ID | jq -r '.builds[0].buildStatus')" = "IN_PROGRESS" ] ; do sleep 1 ; done
if [ "$(aws codebuild batch-get-builds --ids $BUILD_ID | jq -r '.builds[0].buildStatus')" = "FAILED" ] ; then echo "Codebuild project ${aws_codebuild_project.codebuild_image.name} failed" && exit 1 ; fi
echo "${aws_codebuild_project.codebuild_image.name} result: $(aws codebuild batch-get-builds --ids $BUILD_ID | jq -r '.builds[0].buildStatus')"
EOF
  }
}

