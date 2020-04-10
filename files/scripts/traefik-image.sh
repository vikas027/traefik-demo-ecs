#!/usr/bin/env bash

# This script build a custom

# Build Docker Image
TRAEFIK_VERSION="v1.7.24"
cd ./files/docker/traefik && docker build -t traefik:${TRAEFIK_VERSION}-alpine-ecs .

# Create ECR Repo (if it does not exists) and Push Docker Image
aws ecr create-repository --repository-name traefik || echo
$(aws ecr get-login --no-include-email)
docker tag traefik:${TRAEFIK_VERSION}-alpine-ecs $(aws sts get-caller-identity | jq -r .Account).dkr.ecr.ap-southeast-2.amazonaws.com/traefik:${TRAEFIK_VERSION}-alpine-ecs
docker push $(aws sts get-caller-identity | jq -r .Account).dkr.ecr.ap-southeast-2.amazonaws.com/traefik:${TRAEFIK_VERSION}-alpine-ecs
