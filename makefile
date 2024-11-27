# Data Infra Makefile

# <Special Targets>
.EXPORT_ALL_VARIABLES:
.ONESHELL:
# </Special Targets>

# Define directories
TERRAFORM_DIR_MAIN = ./terraform/aws-apigateway-s3
TERRAFORM_DIR_TFVARS = ./infra/data-platform-non-prod/us-east-1/aws-apigateway-s3
TFVARS_FILE = $(TERRAFORM_DIR_TFVARS)/terraform.tfvars

# Print the working directory for debugging purposes
print_dir:
	@echo "Current Directory: $(shell pwd)"

# Terraform commands for the main directory with .tfvars
init:
		@echo "Initializing Terraform..."
		cd $(TERRAFORM_DIR_MAIN) && terraform init -upgrade -backend-config=$(TERRAFORM_DIR_TFVARS)/backend.tfvars

plan:
		@echo "Planning Terraform..."
		cd $(TERRAFORM_DIR_MAIN) && terraform plan -var-file=$(TFVARS_FILE)

apply:
		@echo "Applying Terraform..."
		cd $(TERRAFORM_DIR_MAIN) && terraform apply -var-file=$(TFVARS_FILE) -auto-approve

destroy:
		@echo "Destroying Terraform resources..."
		cd $(TERRAFORM_DIR_MAIN) && terraform destroy -var-file=$(TFVARS_FILE) -auto-approve

# Remove .terraform directory for cleanup
init_remove:
		@echo "Cleaning up Terraform initialization files..."
		cd $(TERRAFORM_DIR_MAIN) && rm -rf .terraform

# Terraform formatting (linting)
tf_lint_with_write:
		@echo "Linting Terraform with write..."
		terraform fmt -recursive -diff=true -write=true $(TERRAFORM_DIR_MAIN)

tf_lint_without_write:
		@echo "Linting Terraform without write..."
		terraform fmt -recursive -diff=true -write=false $(TERRAFORM_DIR_MAIN)

# Python dependencies installation
install_python_deps:
		@echo "Installing Python dependencies..."
		python3 -m pip install --upgrade pip
		python3 -m pip install -r ./scripts/requirements.txt
