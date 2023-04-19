resource "aws_codecommit_repository" "main" {
  repository_name = var.repo_name
  description     = "Repository for TechMahindra Engineering in Cloud"
  default_branch  = "main"
}

resource "null_resource" "git_branch" {
  triggers = {
    aws_codecommit_repository = aws_codecommit_repository.main.id
  }
  
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../"
    command = <<EOF
if [ ! -d ".git" ] ; then
  git init
fi

if git remote | grep "aws" ; then
  git remote remove aws
fi

git config user.email "terraform@terraform.com"
git config user.name "Terraform script"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git remote add aws codecommit::${var.region}://${aws_codecommit_repository.main.repository_name}
git add .
git commit -m "add last changes" 
git push aws $BRANCH:main

EOF
  }
}


