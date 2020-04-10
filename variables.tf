// Common Vars
variable "aws_region" {
  description = "AWS Region"
}

variable "azs" {
  type = list
}

variable "domain" {}

variable "key_name" {}

// VPC
variable "vpc_name" {}

variable "vpc_cidr_block" {
  description = "CIDR Block for VPC"
}

variable "cidr_subnets_private" {
  description = "CIDR Blocks for private subnets in Availability Zones"
  type        = list
}

variable "cidr_subnets_public" {
  description = "CIDR Blocks for public subnets in Availability Zones"
  type        = list
}

// ECS
variable "cluster_name" {
  description = "Name of ECS Cluster"
}

variable "ecs_instance_type" {}

variable "ecs_instance_num" {}

variable "ecs_max_instances" {}

variable "traefik_image" {}
