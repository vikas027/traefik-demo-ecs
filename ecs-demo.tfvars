// Common
aws_region = "ap-southeast-2"

domain = "cli-api.fun"

// ECS
ecs_instance_num = 1

ecs_instance_type = "t2.large"

ecs_max_instances = 5

traefik_image = "traefik:v1.7.20-alpine-ecs"

// VPC
vpc_cidr_block = "10.0.0.0/16"

cidr_subnets_public = ["10.0.0.0/24"]

cidr_subnets_private = ["10.0.1.0/24"]

vpc_id = "vpc-02aaef3c7ffa90357"
