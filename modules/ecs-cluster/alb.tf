resource "aws_lb" "ecs-ingress" {
  name                             = "ecs-${var.cluster_name}-app-alb"
  load_balancer_type               = "application"
  internal                         = false
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.ecs_alb_sg.id]
  subnets                          = [for subnet in data.aws_subnet_ids.public.ids : subnet]
}

resource "aws_lb_listener" "ecs-ingress-http" {
  load_balancer_arn = aws_lb.ecs-ingress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-ingress-http.arn
  }
}

resource "aws_lb_target_group" "ecs-ingress-http" {
  name     = "ecs-${var.cluster_name}-ingress-http"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = "/ping"
    port     = 80
  }
}
