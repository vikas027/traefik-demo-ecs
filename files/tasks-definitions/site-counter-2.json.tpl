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
        "environment": [
            {
                "name": "SHOW_IP",
                "value": "false"
            }
        ],
        "command": null,
        "linuxParameters": null,
        "resourceRequirements": null,
        "ulimits": null,
        "dnsServers": null,
        "mountPoints": [],
        "workingDirectory": null,
        "secrets": null,
        "dockerSecurityOptions": null,
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
            "traefik.http.routers.${service_name}.rule": "Host(`${service_name}.${domain}`)",
            "traefik.enable": "true"
        },
        "systemControls": null,
        "privileged": false,
        "name": "${service_name}"
    }
]
