#!make

# Usage:
# make help

TRAEFIK_VERSION := v2.5.3
ACCOUNT_ID := $(shell aws sts get-caller-identity | jq -r .Account)
AWS_REGION := ap-southeast-2
KEYPAIR := ecs-demo-key

## TARGETS
.ONESHELL:
.PHONY: clean
clean:
	rm -rf .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info

.PHONY: build-push-docker-image
build-push-docker-image:
	@echo "\n## Build a docker image and push it to ECR\n"
	DOCKER_BUILDKIT=1 docker build -t traefik:$(TRAEFIK_VERSION)-alpine-ecs -f ./files/docker/traefikv2/Dockerfile .
	aws ecr create-repository --repository-name traefik || echo
	$$(aws ecr --region $(AWS_REGION) get-login --no-include-email)
	docker tag traefik:$(TRAEFIK_VERSION)-alpine-ecs $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/traefik:$(TRAEFIK_VERSION)-alpine-ecs
	docker push $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/traefik:$(TRAEFIK_VERSION)-alpine-ecs

.PHONY: create-key-pair
create-key-pair:
	@echo "\n## Create a Key Pair\n"
	test -f $(KEYPAIR).pub || ssh-keygen -t rsa -N "" -f $(KEYPAIR)
	test -f $(KEYPAIR).pub && aws ec2 import-key-pair --key-name "$(KEYPAIR)" --public-key-material file:///Users/vikas/MY_STUFF/GIT/traefik-demo-ecs/$(KEYPAIR).pub || echo

.PHONY: pre-reqs
pre-reqs: build-push-docker-image create-key-pair

.PHONY: tf-init
tf-init:
	@echo "\n## Initialize Terraform\n"
	terraform init

.PHONY: tf-plan
tf-plan: tf-init
	@echo "\n## Terraform Plan\n"
	TF_VAR_traefik_image=traefik:$(TRAEFIK_VERSION)-alpine-ecs terraform plan -var-file=./ecs-demo.tfvars -out plan.out
	# TF_LOG=TRACE TF_VAR_traefik_image=traefik:$(TRAEFIK_VERSION)-alpine-ecs terraform plan -var-file=./ecs-demo.tfvars -out plan.out

.PHONY: tf-apply
tf-apply: tf-plan
	@echo "\n## Terraform Apply\n"
	terraform apply -auto-approve plan.out

.PHONY: tf-destroy
tf-destroy: tf-init
	@echo "\n## Terraform Destroy\n"
	TF_VAR_traefik_image=traefik:$(TRAEFIK_VERSION)-alpine-ecs terraform destroy -var-file=./ecs-demo.tfvars -force

.PHONY: nuke
nuke: tf-destroy
	@echo "\n## Nuke Everything\n"
	rm -fv $(KEYPAIR)* output.txt
	aws ec2 delete-key-pair --key-name $(KEYPAIR) || echo
	aws ecr delete-repository --repository-name traefik --force || echo
	$(MAKE) clean

## USAGE
help:
	@echo "Usage: make <target>'"
	@echo "  build-push-docker-image    Build a docker image and push it to ECR"
	@echo "  tf-init                    Initialize terraform environment"
	@echo "  tf-plan                    Execute Terraform Plan (see which resources is Terraform going to create/update)"
	@echo "  tf-apply                   Execute Terraform Apply"
	@echo "  tf-destroy                 Execute Terraform Force Destroy"
	@echo "  nuke                       Destroy everything"
