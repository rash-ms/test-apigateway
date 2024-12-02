TERRAFORM_ROOT_DIR = infra
# infra
# /Users/madeniji/Documents/dev-code/test-apigateway/infra
RESOURCE_DIR = $(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3
TFVARS_DIR = $(TERRAFORM_ROOT_DIR)/data-platform-non-prod/us-east-1/aws-apigateway-s3
TFVARS_FILE = $(TFVARS_DIR)/terraform.tfvars
BACKEND_FILE = $(TFVARS_DIR)/backend.tfvars

# Initialize Terraform
init:
	@echo "Initializing Terraform in $(RESOURCE_DIR)..."
	@echo "Using backend file: $(BACKEND_FILE)"
	@if [ -f "$(BACKEND_FILE)" ]; then \
		if [ -d "$(RESOURCE_DIR)" ]; then \
			cd $(RESOURCE_DIR) && terraform init -backend-config=$(BACKEND_FILE); \
		else \
			echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
		fi; \
	else \
		echo "Error: Backend file $(BACKEND_FILE) not found."; exit 1; \
	fi

# Terraform planning
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

# Terraform applying
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

# Terraform destroying
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

# Cleanup Terraform state
clean:
	@echo "Cleaning up .terraform directories in $(RESOURCE_DIR)..."
	@if [ -d $(RESOURCE_DIR) ]; then \
		find $(RESOURCE_DIR) -name ".terraform" -exec rm -rf {} +; \
	else \
		echo "Error: Terraform resource directory $(RESOURCE_DIR) not found."; exit 1; \
	fi

# Linting Terraform files
lint:
	@echo "Linting all Terraform files in $(TERRAFORM_ROOT_DIR)..."
	terraform fmt -recursive $(TERRAFORM_ROOT_DIR)


# Target: Install Python dependencies
install_python_deps:
	@echo "Installing Python dependencies..."
	python3 -m pip install --upgrade pip
	python3 -m pip install -r ./scripts/requirements.txt
