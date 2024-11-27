# Data Infra Makefile

# <Special Targets>
.EXPORT_ALL_VARIABLES:
.ONESHELL:
# </Special Targets>

# Define directories and files
TERRAFORM_ROOT_DIR = ./infra
RESOURCE_DIR = $(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3
TFVARS_DIR = $(TERRAFORM_ROOT_DIR)/data-platform-non-prod/us-east-1/aws-apigateway-s3
TFVARS_FILE = $(TFVARS_DIR)/terraform.tfvars
BACKEND_FILE = $(TFVARS_DIR)/backend.tfvars

# Target: Initialize Terraform
init:
	@echo "Initializing Terraform in $(RESOURCE_DIR)..."
	@if [ -f $(BACKEND_FILE) ]; then \
		if [ -d $(RESOURCE_DIR) ]; then \
			cd $(RESOURCE_DIR) && terraform init -upgrade -backend-config=$(BACKEND_FILE); \
		else \
			echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
		fi; \
	else \
		echo "Error: Backend file $(BACKEND_FILE) not found."; exit 1; \
	fi

# Target: Plan Terraform deployment
plan:
	@echo "Planning Terraform in $(RESOURCE_DIR)..."
	@if [ -f $(TFVARS_FILE) ]; then \
		if [ -d $(RESOURCE_DIR) ]; then \
			cd $(RESOURCE_DIR) && terraform plan -var-file=$(TFVARS_FILE); \
		else \
			echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
		fi; \
	else \
		echo "Error: Variable file $(TFVARS_FILE) not found."; exit 1; \
	fi

# Target: Apply Terraform deployment
apply:
	@echo "Applying Terraform in $(RESOURCE_DIR)..."
	@if [ -f $(TFVARS_FILE) ]; then \
		if [ -d $(RESOURCE_DIR) ]; then \
			cd $(RESOURCE_DIR) && terraform apply -var-file=$(TFVARS_FILE) -auto-approve; \
		else \
			echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
		fi; \
	else \
		echo "Error: Variable file $(TFVARS_FILE) not found."; exit 1; \
	fi

# Target: Destroy Terraform deployment
destroy:
	@echo "Destroying Terraform resources in $(RESOURCE_DIR)..."
	@if [ -f $(TFVARS_FILE) ]; then \
		if [ -d $(RESOURCE_DIR) ]; then \
			cd $(RESOURCE_DIR) && terraform destroy -var-file=$(TFVARS_FILE) -auto-approve; \
		else \
			echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
		fi; \
	else \
		echo "Error: Variable file $(TFVARS_FILE) not found."; exit 1; \
	fi

# Target: Clean up Terraform directories
clean:
	@echo "Cleaning up .terraform directories in $(RESOURCE_DIR)..."
	@if [ -d $(RESOURCE_DIR) ]; then \
		find $(RESOURCE_DIR) -name ".terraform" -exec rm -rf {} +; \
	else \
		echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
	fi

# Target: Lint and format Terraform files
tf_lint_with_write:
	@echo "Linting all Terraform code (write mode)..."
	terraform fmt -recursive -diff=true -write=true $(TERRAFORM_ROOT_DIR)

tf_lint_without_write:
	@echo "Linting all Terraform code (dry-run)..."
	terraform fmt -recursive -diff=true -write=false $(TERRAFORM_ROOT_DIR)

# Target: Install Python dependencies
install_python_deps:
	@echo "Installing Python dependencies..."
	python3 -m pip install --upgrade pip
	python3 -m pip install -r ./scripts/requirements.txt
