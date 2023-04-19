
provider "aws" {
  alias = "replica_region"
}
provider "aws" {
}


resource "aws_dynamodb_table" "source_table" {

  hash_key         = var.hash_key
  name             = "${var.run_env}-${var.name}"
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
 
  dynamic  "attribute" {
    for_each = var.attributes
    content {
      name = lookup(attribute.value, "name", null)
      type = lookup(attribute.value, "type", null)
    }
  }
  point_in_time_recovery {
    enabled = var.recovery_point_flag
  }
}

resource "aws_dynamodb_table" "replica_table" {
  count = var.enable_replica ? 1 : 0
  provider = "aws.replica_region"

  hash_key         = var.hash_key
  name             = "${var.run_env}-${var.name}"
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
 
  dynamic  "attribute" {
    for_each = var.attributes
    content {
      name = lookup(attribute.value, "name", null)
      type = lookup(attribute.value, "type", null)
    }
  }
  point_in_time_recovery {
    enabled = var.recovery_point_flag
  }
}

resource "aws_dynamodb_global_table" "global_table" {
  count = var.enable_replica ? 1 : 0
  depends_on = [aws_dynamodb_table.source_table]

  name = "${var.run_env}-${var.name}"

  replica {
    region_name = var.source_region
  }

  replica {
    region_name = var.replica_region
  }
}