terraform {
  required_version = ">= 0.12"

  required_providers {
    aws      = "2.55.0"
    template = "2.1.2"
    local    = "1.4.0"
  }
}

module "vpc" {
  source              = "git::https://github.com/rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git//?ref=v0.12.0"
  name                = var.vpc_name
  cidr_range          = var.vpc_cidr_block
  custom_azs          = var.azs
  az_count            = length(var.azs)
  public_cidr_ranges  = var.cidr_subnets_public
  private_cidr_ranges = var.cidr_subnets_private
}

module "ecs-cluster" {
  source            = "./modules/ecs-cluster"
  vpc_id            = module.vpc.vpc_id
  vpc_cidr_block    = var.vpc_cidr_block
  ecs_instance_type = var.ecs_instance_type
  ecs_instance_num  = var.ecs_instance_num
  ecs_max_instances = var.ecs_max_instances
  key_name          = var.key_name
  cluster_name      = var.cluster_name
  domain            = var.domain
  traefik_image     = var.traefik_image
}
