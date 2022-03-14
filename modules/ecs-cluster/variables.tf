variable "vpc_id" {}

variable "vpc_cidr_block" {}

variable "ecs_instance_type" {}

variable "ecs_instance_num" {}

variable "ecs_max_instances" {}

variable "key_name" {}

variable "cluster_name" {}

variable "domain" {}

variable "traefik_image" {}

variable "cw_log_group_retention_in_days" {
  description = "Number of days to keep logs in CloudWatch"
  type        = string
  default     = "3"
}
