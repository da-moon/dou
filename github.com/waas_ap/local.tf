# hello world service
locals {
  # name of the service in ECS
  service_name = "waas"

  # ALB health check url
  health_check_path = "/health"

  # interval of number of seconds to perform health check
  health_check_interval = 12

  # number of times that an unhealthy instance must be healthy in order to be added back into the ALB
  health_check_healthy_threshold = 2

  # number of a times that a healthy instance fails before removale from the ALB
  health_check_unhealthy_threshold = 5

  # how long to wait for the health check path. A timeout indicates a failure.
  health_check_timeout = 5

  # grace period for starting health check if needed.
  health_check_grace_period_seconds = 30

  # the ALB port (usually 80)
  lb_port = 80

  scaling_memory_threshold = "200"
  # The port your container is listening for traffic on
  container_port = 8000

  cpu_scaling_metric_period = 180

  # Add consul & Vault key params here

  # memeory
  container_memory             = 256
  container_memory_reservation = 256
  task_iam_role                = data.terraform_remote_state.landing_zone.outputs.ecs_task_role_arn
  cluster_name                 = data.terraform_remote_state.landing_zone.outputs.cass_cluster
  vault_token                  = "cccca932-8805-f7bc-2c0c-f14da5018919"
  consul_token                 = "aQGs8vpfZmCPmipJzplioPc0icCAAZchQGCkGiH8JSw="
  keys_dir                     = "django_secrets"

}
