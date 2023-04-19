resource "aws_elasticache_subnet_group" "spinnaker" {
  name       = "spinnaker"
  subnet_ids = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  depends_on = [
    module.eks
  ]
}

resource "aws_elasticache_replication_group" "spinnaker" {
  automatic_failover_enabled = true
  # availability_zones            = ["us-west-2a", "us-west-2b", "us-west-2c"]
  availability_zones            = data.aws_availability_zones.available.names
  replication_group_id          = "spinnaker"
  replication_group_description = "Replication group for Elasticache Spin"
  node_type                     = "cache.r5.large"
  number_cache_clusters         = 3
  parameter_group_name          = aws_elasticache_parameter_group.default.id
  engine                        = "redis"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.spinnaker.name
  security_group_ids            = [module.eks.worker_security_group_id]

  depends_on = [
    aws_elasticache_subnet_group.spinnaker,
    aws_elasticache_parameter_group.default,
    module.eks
  ]

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_parameter_group" "default" {
  name        = "redisspinnaker6"
  family      = "redis6.x"
  description = "modified PG for redis, allows permisions for clouddriver initial commands"

  parameter {
    name  = "notify-keyspace-events"
    value = "gxE"
  }

  depends_on = [
    module.eks
  ]
}