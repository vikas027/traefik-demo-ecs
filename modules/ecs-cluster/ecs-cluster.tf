locals {
  ecs_instance_userdata = <<USERDATA
#!/bin/bash -x
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${var.cluster_name}
EOF
USERDATA
}

resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix                 = "ecs-${var.cluster_name}"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance.name
  image_id                    = data.aws_ami.ecs_instance.id
  instance_type               = var.ecs_instance_type
  security_groups             = [aws_security_group.ecs_instance_sg.id]
  user_data_base64            = base64encode(local.ecs_instance_userdata)
  key_name                    = var.key_name
  ebs_optimized               = false

  root_block_device {
    delete_on_termination = true
    encrypted             = true
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  depends_on                = [aws_ecs_cluster.ecs]
  name                      = "ecs-${var.cluster_name}"
  launch_configuration      = aws_launch_configuration.ecs_launch_config.id
  health_check_type         = "EC2"
  min_size                  = var.ecs_instance_num
  max_size                  = var.ecs_max_instances
  desired_capacity          = var.ecs_instance_num
  vpc_zone_identifier       = [for subnet in data.aws_subnet_ids.public.ids : subnet]
  target_group_arns         = [aws_lb_target_group.ecs-ingress-http.arn]
  wait_for_capacity_timeout = "10m"
  termination_policies      = ["OldestInstance"]
}
