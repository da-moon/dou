# Example locals.tf file that will work with the default_service. Configure this file as "locals.tf" in the root
# directory of your project

locals {
  ##### name of the service in ECS - MAX 20 CHARACTERS
  service_name                     = "hello-world"

  ##### ALB health check url - /ok is our standard, only modify if you have a good reason
  health_check_path_path                = "/ok"

  ##### interval of number of seconds to perform health check
  health_check_path_interval            = 7

  ##### number of times that an unhealthy instance must be healthy in order to be added back into the ALB
  health_check_path_healthy_threshold   = 2

  ##### number of a times that a healthy instance fails before removal from the ALB
  health_check_path_unhealthy_threshold = 2

  ##### how long to wait for the health check to return. A timeout indicates a failure.
  health_check_path_timeout             = 5

  ##### the ALB port (usually 80) - This is the port you need send traffic to your service on
  alb_port                         = 80

  ##### Cluster name to deploy the service to. Ask DevOps if you don't know.
  #####  Options are: api / web / pm_pro_enterprise / pm_pro_enterprise_web/
  cluster_name                     = "api"

  ##### The port your container is listening for traffic on
  container_port                   = 5000

  ##### the IAM role to use to provide AWS resource permissions to your deployed container. Default = no permissions
  task_iam_role                    = "${data.terraform_remote_state.config.default_api_task_role_arn}"
}
