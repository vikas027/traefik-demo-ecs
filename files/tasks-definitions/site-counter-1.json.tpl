[
    {
        "dnsSearchDomains": null,
        "logConfiguration": null,
        "entryPoint": null,
        "portMappings": [
            {
                "hostPort": 0,
                "protocol": "tcp",
                "containerPort": 80
            }
        ],
        "command": null,
        "linuxParameters": null,
        "cpu": 0,
        "environment": [],
        "resourceRequirements": null,
        "ulimits": null,
        "dnsServers": null,
        "mountPoints": [],
        "workingDirectory": null,
        "secrets": null,
        "dockerSecurityOptions": null,
        "memory": 128,
        "memoryReservation": null,
        "volumesFrom": [],
        "stopTimeout": null,
        "image": "vikas027/site-counter:latest",
        "startTimeout": null,
        "firelensConfiguration": null,
        "dependsOn": null,
        "disableNetworking": null,
        "interactive": null,
        "healthCheck": null,
        "essential": true,
        "links": null,
        "hostname": null,
        "extraHosts": null,
        "pseudoTerminal": null,
        "user": null,
        "readonlyRootFilesystem": null,
        "dockerLabels": {
            "traefik.frontend.rule": "Host:${service_name}.${domain}",
            "traefik.enable": "true",
            "traefik.backend": "${service_name}",
            "traefik.protocol": "http"
        },
        "systemControls": null,
        "privileged": false,
        "name": "${service_name}"
    }
]
