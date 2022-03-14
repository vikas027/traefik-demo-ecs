data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*Private*"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "ecs_instance" {
  most_recent = true
  owners      = ["591542846629"] # by aws

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
