IMAGE:=wordpress
VERSION:=latest
ANSIBLE_ROLES_PATH:=ansible/roles
AWS_PROFILE:=default
AWS_REGION:=us-east-1

check:
	ansible --version
	terraform --version
	packer --version
	docker --version

deps:
	ansible-galaxy role install -p ${ANSIBLE_ROLES_PATH} -r ansible/requirements.yml
	ansible-galaxy collection install -r ansible/collections.yml

ansible-syntax-check:
	ANSIBLE_ROLES_PATH=$(ANSIBLE_ROLES_PATH) ansible-playbook --syntax-check ansible/playbooks/*.yml

validate:
	packer validate packer/wordpress.json

build-local:
	IMAGE_VERSION=${VERSION} packer build packer/wordpress-local.json

build:
	DOCKER_REPOSITORY=`terraform -chdir=terraform/environments/dev/aws-ecr output -json | jq -r .repository_url.value` \
	IMAGE_VERSION=${VERSION} packer build packer/wordpress.json




