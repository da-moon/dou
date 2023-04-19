
resource "aws_iam_role" "health_checker_role" {
  name = "${local.prefix}-health-checker"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "health_checker_policy" {
  name = "${local.prefix}-health-checker"
  role = aws_iam_role.health_checker_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricData",
          "codecommit:GetTree",
          "codecommit:ListPullRequests",
          "codecommit:GetBlob",
          "codecommit:GetReferences",
          "codecommit:ListRepositories",
          "codecommit:GetPullRequestApprovalStates",
          "codecommit:DescribeMergeConflicts",
          "codecommit:ListTagsForResource",
          "codecommit:BatchDescribeMergeConflicts",
          "codecommit:GetCommentsForComparedCommit",
          "codecommit:GetCommentReactions",
          "codecommit:GetCommit",
          "codecommit:GetComment",
          "codecommit:GetCommitHistory",
          "codecommit:GetCommitsFromMergeBase",
          "codecommit:GetApprovalRuleTemplate",
          "codecommit:BatchGetCommits",
          "codecommit:DescribePullRequestEvents",
          "codecommit:GetPullRequest",
          "codecommit:ListAssociatedApprovalRuleTemplatesForRepository",
          "codecommit:ListBranches",
          "codecommit:GetPullRequestOverrideState",
          "codecommit:GetRepositoryTriggers",
          "codecommit:ListApprovalRuleTemplates",
          "codecommit:GitPull",
          "codecommit:BatchGetRepositories",
          "codecommit:GetCommentsForPullRequest",
          "codecommit:GetObjectIdentifier",
          "codecommit:CancelUploadArchive",
          "codecommit:GetFolder",
          "codecommit:BatchGetPullRequests",
          "codecommit:GetFile",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:EvaluatePullRequestApprovalRules",
          "codecommit:ListRepositoriesForApprovalRuleTemplate",
          "codecommit:GetDifferences",
          "codecommit:GetRepository",
          "codecommit:GetBranch",
          "codecommit:GetMergeConflicts",
          "codecommit:GetMergeCommit",
          "codecommit:GetMergeOptions"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
