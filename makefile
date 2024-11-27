# Data Infra MakeFile

# <Special Targets>
.EXPORT_ALL_VARIABLES:
.ONESHELL:
# </Special Targets>

python_exec=$(shell command -v python3)

TERRAFORM_DIR = ./infra

# Authentication
auth:
		saml2aws login

set_env:
		@echo execute eval $(saml2aws script)

# Terraform commands
init:
		cd $(TERRAFORM_DIR) && terraform init -upgrade

plan:
		cd $(TERRAFORM_DIR) && terraform plan

apply:
		cd $(TERRAFORM_DIR) && terraform apply -auto-approve

destroy:
		cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

init_remove:
		cd $(TERRAFORM_DIR) && rm -rf .terraform

# Terraform linting
tf_lint_with_write:
		terraform fmt -recursive -diff=true -write=true $(TERRAFORM_DIR)

tf_lint_without_write:
		terraform fmt -recursive -diff=true -write=false $(TERRAFORM_DIR)

# Python dependencies installation
install_python_deps:
	$(python_exec) -m pip install --upgrade pip
	$(python_exec) -m pip install -r ./scripts/requirements.txt
