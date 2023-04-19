
output "repo_https_url" {
  value = aws_codecommit_repository.main.clone_url_http
}

