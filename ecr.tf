resource "aws_ecr_repository" "plm-repository" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
}


resource "aws_ecr_repository_policy" "plm-repo-policy" {
  repository = aws_ecr_repository.plm-repository.name

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the plm repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:DeleteRepository",
            "ecr:BatchDeleteImage",
            "ecr:SetRepositoryPolicy",
            "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  }
  EOF
}