// Security Group and Rules for ECS ALB
resource "aws_security_group" "ecs_alb_sg" {
  name        = "${var.cluster_name}_ecs_alb_sg"
  description = "ALB SG for cluster ${var.cluster_name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_alb_sg_http" {
  type              = "ingress"
  description       = "Allow HTTP from anywhere"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_alb_sg.id
}

resource "aws_security_group_rule" "ecs_alb_sg_http_to_ecs_nodes" {
  type                     = "egress"
  description              = "HTTP out to ECS Nodes"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_instance_sg.id
  security_group_id        = aws_security_group.ecs_alb_sg.id
}

// Security Group and Rules for ECS Worker Nodes
resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.cluster_name}_ecs_instance_sg"
  description = "ECS Instance SG for cluster ${var.cluster_name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_instance_sg_ssh" {
  type              = "ingress"
  description       = "Allow SSH from VPC"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block, "0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_instance_sg.id
}

resource "aws_security_group_rule" "ecs_instance_sg_http" {
  type                     = "ingress"
  description              = "Allow HTTP from ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_alb_sg.id
  security_group_id        = aws_security_group.ecs_instance_sg.id
}

resource "aws_security_group_rule" "ecs_instance_out_to_all" {
  type              = "egress"
  description       = "Allow everything out of cluster"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_instance_sg.id
}
