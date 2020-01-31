// Common Vars
variable "aws_region" {
  default = "ap-southeast-2"
}

variable "domain" {}

// VPC
variable "vpc_id" {}

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
  default = "traefik-test"
}

variable "ecs_instance_type" {}

variable "ecs_instance_num" {}

variable "ecs_max_instances" {}

variable "traefik_image" {}
