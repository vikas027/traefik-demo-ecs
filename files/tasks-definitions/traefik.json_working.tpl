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
        "image": "${docker_image}",
        "entryPoint": ["traefik", "--providers.ecs.clusters", "${cluster_name}", "--log.level", "DEBUG", "--providers.ecs.region", "${region}", "--api.insecure"],
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
