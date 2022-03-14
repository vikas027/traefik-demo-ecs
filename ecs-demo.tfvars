// Common
aws_region = "ap-southeast-2"

azs = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

domain = "cli-api.fun"

key_name = "ecs-demo-key"

// ECS
cluster_name = "traefik-test"

ecs_instance_num = 1

ecs_instance_type = "t2.large"

ecs_max_instances = 5

// VPC
vpc_name = "ecs-demo"

vpc_cidr_block = "10.61.64.0/20"

cidr_subnets_public = ["10.61.76.64/26", "10.61.76.128/26", "10.61.76.192/26"]

cidr_subnets_private = ["10.61.77.0/24", "10.61.78.0/24", "10.61.79.0/24"]
