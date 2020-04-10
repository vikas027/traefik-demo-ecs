#!make

# Usage:
# make help

## TARGETS
.ONESHELL:

.PHONY: build-push-docker-image
build-push-docker-image:
	@echo "\n## Build a docker image and push it to ECR\n"
	./files/scripts/traefik-image.sh

.PHONY: create-key-pair
create-key-pair:
	@echo "\n## Create a Key Pair\n"
	aws ec2 create-key-pair --key-name ecs-demo-key || echo

.PHONY: pre-reqs
pre-reqs: build-push-docker-image create-key-pair

.PHONY: tf-init
tf-init:
	@echo "\n## Initialize Terraform\n"
	terraform init

.PHONY: tf-plan
tf-plan: tf-init
	@echo "\n## Terraform Plan\n"
	terraform plan -var-file=./ecs-demo.tfvars

.PHONY: tf-apply
tf-apply: tf-plan
	@echo "\n## Terraform Apply\n"
	terraform apply -var-file=./ecs-demo.tfvars -auto-approve

.PHONY: tf-destroy
tf-destroy: tf-init
	@echo "\n## Terraform Destroy\n"
	terraform destroy -var-file=./ecs-demo.tfvars -force

.PHONY: nuke
nuke: tf-destroy
	@echo "\n## Nuke Everything\n"
	aws ec2 delete-key-pair --key-name ecs-demo-key || echo
	aws ecr delete-repository --repository-name traefik --force || echo

## USAGE
help:
	@echo "Usage: make <target>'"
	@echo "  build-push-docker-image    Build a docker image and push it to ECR"
	@echo "  tf-init                    Initialize terraform environment"
	@echo "  tf-plan                    Execute Terraform Plan (see which resources is Terraform going to create/update)"
	@echo "  tf-apply                   Execute Terraform Apply"
	@echo "  tf-destroy                 Execute Terraform Force Destroy"
	@echo "  nuke                       Destroy everything i"
