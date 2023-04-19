
output "codebuild_project_names" {
  value = [for p in aws_codebuild_project.main : p.name]
}