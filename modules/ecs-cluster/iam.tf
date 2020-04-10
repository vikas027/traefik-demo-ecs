// IAM Role for ECS Nodes
resource "aws_iam_role" "ecs_instance_role" {
  name                  = "${var.cluster_name}_ecs_instance_role"
  description           = "IAM Role for ECS Cluster ${var.cluster_name} Worker Nodes"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.cluster_name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

// IAM Role for Task Executions
resource "aws_iam_role" "task_execution_role" {
  name                  = "${var.cluster_name}_ecs_task_execution_role"
  description           = "IAM Role for ECS Cluster ${var.cluster_name} Tasks Execution"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task_execution_role" {
  name = "${var.cluster_name}_ecs_task_execution_role"
  role = aws_iam_role.task_execution_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "arn:aws:ecr:ap-southeast-2:${data.aws_caller_identity.current.account_id}:repository/*"
        },
        {
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

// IAM Role for Traefik Task
resource "aws_iam_role" "ecs_task_traefik_role" {
  name                  = "${var.cluster_name}_ecs_task_traefik_role"
  description           = "IAM Role for ECS Cluster ${var.cluster_name} Traefik Tasks"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_task_traefik_role" {
  name = "${var.cluster_name}_ecs_task_traefik_role"
  role = aws_iam_role.ecs_task_traefik_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TraefikECSReadAccess",
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:DescribeClusters",
        "ecs:ListTasks",
        "ecs:DescribeTasks",
        "ecs:DescribeContainerInstances",
        "ecs:DescribeTaskDefinition",
        "ec2:DescribeInstances",
        "servicediscovery:Get*",
        "servicediscovery:List*",
        "servicediscovery:DiscoverInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
