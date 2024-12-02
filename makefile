# Root directories
TERRAFORM_ROOT_DIR = infra
RESOURCE_DIR = $(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3
TFVARS_DIR = $(TERRAFORM_ROOT_DIR)/data-platform-non-prod/us-east-1/aws-apigateway-s3

# Variable files
TFVARS_FILE = $(TFVARS_DIR)/terraform.tfvars
BACKEND_FILE = $(TFVARS_DIR)/backend.tfvars

# Check if the required directories/files exist
check-dir:
	@if [ ! -d "$(RESOURCE_DIR)" ]; then \
		echo "Error: Resource directory $(RESOURCE_DIR) not found."; exit 1; \
	fi

check-backend-file:
	@if [ ! -f "$(BACKEND_FILE)" ]; then \
		echo "Error: Backend file $(BACKEND_FILE) not found."; exit 1; \
	fi

check-tfvars-file:
	@if [ ! -f "$(TFVARS_FILE)" ]; then \
		echo "Error: Variable file $(TFVARS_FILE) not found."; exit 1; \
	fi

# Terraform initialization
# init: check-dir check-backend-file
# 	@echo "Initializing Terraform in $(RESOURCE_DIR)..."
# 	cd $(RESOURCE_DIR) && terraform init -backend-config=$(BACKEND_FILE)

init: check-dir check-backend-file
	@echo "Initializing Terraform in $(RESOURCE_DIR)..."
	cd $(RESOURCE_DIR) && terraform init -backend-config=$(shell realpath $(BACKEND_FILE))


# Terraform planning
plan: check-dir check-tfvars-file
	@echo "Planning Terraform in $(RESOURCE_DIR)..."
	cd $(RESOURCE_DIR) && terraform plan -var-file=$(TFVARS_FILE)

# Terraform applying
apply: check-dir check-tfvars-file
	@echo "Applying Terraform in $(RESOURCE_DIR)..."
	cd $(RESOURCE_DIR) && terraform apply -var-file=$(TFVARS_FILE) -auto-approve

# Terraform destroying
destroy: check-dir check-tfvars-file
	@echo "Destroying Terraform resources in $(RESOURCE_DIR)..."
	cd $(RESOURCE_DIR) && terraform destroy -var-file=$(TFVARS_FILE) -auto-approve

# Cleanup Terraform state
clean: check-dir
	@echo "Cleaning up .terraform directories in $(RESOURCE_DIR)..."
	find $(RESOURCE_DIR) -name ".terraform" -exec rm -rf {} +

# Linting Terraform files
lint:
	@echo "Linting all Terraform files in $(TERRAFORM_ROOT_DIR)..."
	terraform fmt -recursive $(TERRAFORM_ROOT_DIR)

# Install Python dependencies
install_python_deps:
	@echo "Installing Python dependencies..."
	python3 -m pip install --upgrade pip
	python3 -m pip install -r ./scripts/requirements.txt
