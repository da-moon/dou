# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── TASK ROLES ────────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# - policy for enabling a task to assume a role
# - Fargate requires ecs-tasks.amazonaws.com
# as identifier
# - we are using a single principle, this principle
# ensures that only AWS ECS can assume the role, and nobody else.
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# ─────────────────────────────────────────────────────────────────────
data "aws_iam_policy_document" "task_execution" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# ECS task execution role
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# ─────────────────────────────────────────────────────────────────────
resource "aws_iam_role" "task_execution" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
  ]
  name               = "${var.project_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_execution.json
}
# ──── NOTE ──────────────────────────────────────────────────────────
# binds task execution policy to IAM role
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
# ─────────────────────────────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "task_execution" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#
# ──── TASK DEFINITION ────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# accepted Fargate CPU/Memory values
#
# |-----------|----------------------------------------------|
# | CPU Value | Memory Value                                 |
# |-----------|----------------------------------------------|
# | 256       | 512,1024,2048                                |
# |-----------|----------------------------------------------|
# | 512       | 1024,2048 3072                               |
# |-----------|----------------------------------------------|
# | 1024      | 2048, 3072,4096,5120,6144,7168,8192          |
# |-----------|----------------------------------------------|
# | 2048      | Between 4096 and 16384 in increments of 1024 |
# |-----------|----------------------------------------------|
# | 4096      | Between 8192 and 30720 in increments of 1024 |
# |-----------|----------------------------------------------|
# ─────────────────────────────────────────────────────────────────────
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
# ─────────────────────────────────────────────────────────────────────
data "template_file" "container_definitions" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  template = file("${path.module}/templates/container_definitions.json.tpl")
  vars = {
    execution_role_arn = aws_iam_role.task_execution.arn
    name               = var.docker_image_tag
    image              = local.image
    app_port           = var.app_port
    memory             = var.memory_limit
    cpu                = var.cpu_limit
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# uses the rendered template to setup Elastic Container Service task
# definition
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecs_task_definition" "this" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
  ]
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = var.project_name
  cpu                      = var.cpu_limit
  memory                   = var.memory_limit
  execution_role_arn       = aws_iam_role.task_execution.arn
  container_definitions    = data.template_file.container_definitions.rendered
}

#
# ──── ECS CLUSTER ────────────────────────────────────────────────────
#


# ──── NOTE ──────────────────────────────────────────────────────────
# sets up an ECS cluster
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecs_cluster" "this" {
  name               = "${var.project_name}-cluster"
  capacity_providers = ["FARGATE"]
  tags = {
    Name = "${var.project_name}-cluster"
  }
}


# ──── NOTE ──────────────────────────────────────────────────────────
# Traffic to the ECS Cluster should only come from the ALB
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# ─────────────────────────────────────────────────────────────────────
resource "aws_security_group" "this" {
  name        = "${var.project_name}-tasks"
  description = "Fargate service security group which allows ingress only from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = ["${var.alb_sg_id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-ecs-task-security-group"
  }
}

# ──── NOTE ──────────────────────────────────────────────────────────
# sets up an ecs service
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecs_service" "this" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
  ]
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = ["${aws_security_group.this.id}"]
    subnets         = var.private_subnet_ids
  }
  load_balancer {
    target_group_arn = var.alb_target_group_id
    container_name   = var.docker_image_tag
    container_port   = var.app_port
  }
  tags = {
    Name = "${var.project_name}-ecs-definition"
  }
}
