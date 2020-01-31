terraform {
  required_version = ">= 0.12"

  required_providers {
    aws      = "2.46.0"
    template = "2.1.2"
    local    = "1.4.0"
  }
}

module "ecs-cluster" {
  source            = "./modules/ecs-cluster"
  vpc_id            = var.vpc_id
  vpc_cidr_block    = var.vpc_cidr_block
  ecs_instance_type = var.ecs_instance_type
  ecs_instance_num  = var.ecs_instance_num
  ecs_max_instances = var.ecs_max_instances
  key_name          = var.key_name
  cluster_name      = var.cluster_name
  domain            = var.domain
  traefik_image     = var.traefik_image
}
