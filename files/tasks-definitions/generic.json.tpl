[
    {
        "name": "${service_name}",
        "image": "${docker_image}",
        "essential": true,
        "portMappings": [
            {
                "hostPort": 0,
                "protocol": "tcp",
                "containerPort": 80
            }
        ],
        "dockerLabels": {
            "traefik.http.routers.${service_name}.rule": "Host(`${service_name}.${domain}`)",
            "traefik.enable": "true"
        }
    }
]
