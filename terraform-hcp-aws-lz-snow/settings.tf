provider "aws" {
  default_tags {
    tags = {
      Environment = var.aws_tag_environment
      Service     = var.aws_tag_service
      Owner       = var.aws_tag_owner
      TTL         = var.aws_tag_ttl
    }
  }
}
