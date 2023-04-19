resource "aws_fsx_openzfs_file_system" "fs" {
  storage_capacity    = var.storage_capacity
  subnet_ids          = var.subnet_ids
  deployment_type     = "SINGLE_AZ_1"
  throughput_capacity = var.throughput_capacity
  security_group_ids  = var.security_group_ids

  root_volume_configuration {
    data_compression_type = "ZSTD"
    nfs_exports {
      client_configurations {
        clients = "*"
        options = ["rw","crossmnt", "no_root_squash", "async"]
      }
    }
  }

  automatic_backup_retention_days = 0

  tags = {
    Name        = var.fsx_name
  }
}