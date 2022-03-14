// Traefik Task and Service
resource "aws_cloudwatch_log_group" "traefik" {
  name              = "/aws/ecs/${var.cluster_name}/traefik"
  retention_in_days = var.cw_log_group_retention_in_days
}

data "template_file" "traefik_task_definition" {
  template = file("./files/tasks-definitions/traefik.json.tpl")

  vars = {
    name         = "traefik"
    cluster_name = var.cluster_name
    region       = data.aws_region.current.name
    domain       = var.domain
    # account_id   = data.aws_caller_identity.current.account_id
    docker_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/traefik:v2.5.3-alpine-ecs"
    # docker_image = "traefik:2.5.3"
    log_group = aws_cloudwatch_log_group.traefik.name
  }
}

resource "aws_ecs_task_definition" "traefik" {
  family                   = "traefik"
  container_definitions    = data.template_file.traefik_task_definition.rendered
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_traefik_role.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "traefik" {
  depends_on          = [aws_autoscaling_group.ecs]
  name                = "traefik"
  cluster             = aws_ecs_cluster.ecs.id
  desired_count       = 1
  launch_type         = "EC2"
  task_definition     = aws_ecs_task_definition.traefik.arn
  scheduling_strategy = "DAEMON"
  propagate_tags      = "SERVICE"
}

// Test Task and Service - site-counter-1
data "template_file" "task_definition_site-counter-1" {
  template = file("./files/tasks-definitions/generic.json.tpl")

  vars = {
    service_name = "site-counter-1"
    domain       = var.domain
    docker_image = "vikas027/site-counter:latest"
  }
}

resource "aws_ecs_task_definition" "site-counter-1" {
  family                   = "site-counter-1"
  container_definitions    = data.template_file.task_definition_site-counter-1.rendered
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_traefik_role.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 128
  memory                   = 256
}

resource "aws_ecs_service" "site-counter-1" {
  depends_on      = [aws_autoscaling_group.ecs]
  name            = "site-counter-1"
  cluster         = aws_ecs_cluster.ecs.id
  desired_count   = 2
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.site-counter-1.arn
  propagate_tags  = "SERVICE"
}

// Test Task and Service - site-counter-2
data "template_file" "task_definition_site-counter-2" {
  template = file("./files/tasks-definitions/site-counter-2.json.tpl")

  vars = {
    service_name = "site-counter-2"
    domain       = var.domain
    docker_image = "vikas027/site-counter:latest"
  }
}

resource "aws_ecs_task_definition" "site-counter-2" {
  family                   = "site-counter-2"
  container_definitions    = data.template_file.task_definition_site-counter-2.rendered
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_traefik_role.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 128
  memory                   = 256
}

resource "aws_ecs_service" "site-counter-2" {
  depends_on      = [aws_autoscaling_group.ecs]
  name            = "site-counter-2"
  cluster         = aws_ecs_cluster.ecs.id
  desired_count   = 2
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.site-counter-2.arn
  propagate_tags  = "SERVICE"
}

// whoami
data "template_file" "whoami" {
  template = file("./files/tasks-definitions/generic.json.tpl")

  vars = {
    service_name = "whoami"
    domain       = var.domain
    docker_image = "containous/whoami:v1.5.0"
  }
}

resource "aws_ecs_task_definition" "whoami" {
  family                   = "whoami"
  container_definitions    = data.template_file.whoami.rendered
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_traefik_role.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 128
  memory                   = 64
}

resource "aws_ecs_service" "whoami" {
  name            = "whoami"
  cluster         = aws_ecs_cluster.ecs.id
  desired_count   = 1
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.whoami.arn
  propagate_tags  = "SERVICE"
}
