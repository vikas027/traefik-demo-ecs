#!/usr/bin/env bash

# Build Docker Image
cd ./files/docker/traefik && docker build -t traefik:v1.7.20-alpine-ecs .

# Create ECR Repo and Push Docker Image
aws ecr create-repository --repository-name traefik || echo
$(aws ecr get-login --no-include-email)
docker tag traefik:v1.7.20-alpine-ecs $(aws sts get-caller-identity | jq -r .Account).dkr.ecr.ap-southeast-2.amazonaws.com/traefik:v1.7.20-alpine-ecs
docker push $(aws sts get-caller-identity | jq -r .Account).dkr.ecr.ap-southeast-2.amazonaws.com/traefik:v1.7.20-alpine-ecs
