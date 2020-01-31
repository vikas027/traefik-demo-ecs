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
            }
        ],
        "name": "${name}",
        "mountPoints": [],
        "image": "${account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/${docker_image}",
        "cpu": 0,
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
        "memory": 512,
        "privileged": true,
        "essential": true,
        "volumesFrom": []
    }
]
