# Data Infra Makefile

# <Special Targets>
.EXPORT_ALL_VARIABLES:
.ONESHELL:
# </Special Targets>

# Define root directory for Terraform
TERRAFORM_ROOT_DIR = ./infra
TFVARS_DIR = $(TERRAFORM_ROOT_DIR)/data-platform-non-prod/us-east-1
TFVARS_FILE = $(TFVARS_DIR)/aws-apigateway-s3/terraform.tfvars

# Helper functions to dynamically work with Terraform directories
define TERRAFORM_CMD
    @echo "Running Terraform in: $1"
    if [ -d $1 ]; then \
        cd $1 && terraform $2; \
    else \
        echo "Error: Directory $1 does not exist"; exit 1; \
    fi
endef

# Common Terraform actions
init:
	@echo "Initializing all Terraform directories under $(TERRAFORM_ROOT_DIR)..."
	$(call TERRAFORM_CMD,$(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3,"init -upgrade -backend-config=$(TFVARS_DIR)/aws-apigateway-s3/backend.tfvars")

plan:
	@echo "Planning Terraform for resources..."
	$(call TERRAFORM_CMD,$(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3,"plan -var-file=$(TFVARS_FILE)")

apply:
	@echo "Applying Terraform resources..."
	$(call TERRAFORM_CMD,$(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3,"apply -var-file=$(TFVARS_FILE) -auto-approve")

destroy:
	@echo "Destroying Terraform resources..."
	$(call TERRAFORM_CMD,$(TERRAFORM_ROOT_DIR)/terraform/aws-apigateway-s3,"destroy -var-file=$(TFVARS_FILE) -auto-approve")

# Cleanup Terraform init directories
clean:
	@echo "Cleaning up .terraform directories..."
	@if [ -d $(TERRAFORM_ROOT_DIR) ]; then \
		find $(TERRAFORM_ROOT_DIR) -name ".terraform" -exec rm -rf {} +; \
	else \
		echo "Error: Root directory $(TERRAFORM_ROOT_DIR) not found"; exit 1; \
	fi

# Lint Terraform code across all subdirectories
tf_lint_with_write:
	@echo "Linting all Terraform code with write..."
	terraform fmt -recursive -diff=true -write=true $(TERRAFORM_ROOT_DIR)

tf_lint_without_write:
	@echo "Linting all Terraform code without write..."
	terraform fmt -recursive -diff=true -write=false $(TERRAFORM_ROOT_DIR)
