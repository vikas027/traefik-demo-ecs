[
    {
        "environment": [
            {
                "name": "CLUSTER_HOST",
                "value": "${cluster_name}"
            },
            {
                "name": "DOMAIN",
                "value": "${domain}"
            },
            {
                "name": "REGION",
                "value": "${region}"
            }
        ],
        "name": "${name}",
        "image": "${docker_image}",
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": 80,
                "hostPort": 80
            }
        ],
        "dockerLabels": {
            "traefik.enable": "false"
        },
        "essential": true,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "${name}"
            }
        }
    }
]
