# Data Infra MakeFile

# <Special Targets>
.EXPORT_ALL_VARIABLES:
.ONESHELL:
# </Special Targets>

python_exec=$(shell command -v python3)

# Define Terraform directories
TERRAFORM_DIR_INFRA = ./infra/data-platform-non-prod/us-east-1/aws-apigateway-s3
TERRAFORM_DIR_MAIN = ./terraform/aws-apigateway-s3

# Authentication
auth:
		saml2aws login

set_env:
		@echo execute eval $(saml2aws script)

# Terraform commands for infra directory
init_infra:
		cd $(TERRAFORM_DIR_INFRA) && terraform init -upgrade

plan_infra:
		cd $(TERRAFORM_DIR_INFRA) && terraform plan

apply_infra:
		cd $(TERRAFORM_DIR_INFRA) && terraform apply -auto-approve

destroy_infra:
		cd $(TERRAFORM_DIR_INFRA) && terraform destroy -auto-approve

# Terraform commands for main terraform directory
init_main:
		cd $(TERRAFORM_DIR_MAIN) && terraform init -upgrade

plan_main:
		cd $(TERRAFORM_DIR_MAIN) && terraform plan

apply_main:
		cd $(TERRAFORM_DIR_MAIN) && terraform apply -auto-approve

destroy_main:
		cd $(TERRAFORM_DIR_MAIN) && terraform destroy -auto-approve

# Terraform linting
tf_lint_with_write:
		terraform fmt -recursive -diff=true -write=true $(TERRAFORM_DIR_INFRA)
		terraform fmt -recursive -diff=true -write=true $(TERRAFORM_DIR_MAIN)

tf_lint_without_write:
		terraform fmt -recursive -diff=true -write=false $(TERRAFORM_DIR_INFRA)
		terraform fmt -recursive -diff=true -write=false $(TERRAFORM_DIR_MAIN)

# Remove Terraform initialization for both directories
init_remove_infra:
		cd $(TERRAFORM_DIR_INFRA) && rm -rf .terraform

init_remove_main:
		cd $(TERRAFORM_DIR_MAIN) && rm -rf .terraform

# Python dependencies installation
install_python_deps:
	$(python_exec) -m pip install --upgrade pip
	$(python_exec) -m pip install -r ./scripts/requirements.txt
