# Makefile for Terragrunt Infrastructure Management

.PHONY: help install validate fmt check init plan apply destroy clean

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Installation & Setup
install: ## Install dependencies (terraform, terragrunt, pre-commit)
	@echo "Installing dependencies..."
	@which terraform || (echo "Please install Terraform >= 1.10.0" && exit 1)
	@which terragrunt || (echo "Please install Terragrunt >= 0.50.0" && exit 1)
	@which pre-commit || (echo "Please install pre-commit" && exit 1)
	@pre-commit install
	@echo "Dependencies installed successfully!"

##@ Validation & Formatting
validate: ## Validate all terragrunt configurations
	@echo "Validating terragrunt configurations..."
	@terragrunt run-all validate

fmt: ## Format all terraform files
	@echo "Formatting terraform files..."
	@terragrunt run-all fmt

check: fmt validate ## Run all checks (format + validate)

##@ Infrastructure Management
init: ## Initialize all terragrunt configurations
	@echo "Initializing terragrunt configurations..."
	@terragrunt run-all init

plan: init ## Plan changes for all components
	@echo "Planning infrastructure changes..."
	@terragrunt run-all plan

plan-billing: init ## Plan changes for billing alerts only
	@echo "Planning billing alert changes..."
	@cd billing-alert && terragrunt plan

apply: init ## Apply changes for all components
	@echo "Applying infrastructure changes..."
	@terragrunt run-all apply

apply-billing: init ## Apply changes for billing alerts only
	@echo "Applying billing alert changes..."
	@cd billing-alert && terragrunt apply

destroy: ## Destroy all infrastructure (use with caution!)
	@echo "WARNING: This will destroy all infrastructure!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		terragrunt run-all destroy; \
	fi

##@ State Management
state-list: ## List all resources in state
	@terragrunt run-all state list

state-show: ## Show details of a specific resource (usage: make state-show RESOURCE=resource_name)
	@if [ -z "$(RESOURCE)" ]; then \
		echo "Usage: make state-show RESOURCE=resource_name"; \
		exit 1; \
	fi
	@terragrunt run-all state show $(RESOURCE)

##@ Utilities
clean: ## Clean up temporary files
	@echo "Cleaning up temporary files..."
	@find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".terragrunt-cache" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "terraform.tfstate*" -type f -delete 2>/dev/null || true
	@echo "Cleanup completed!"

docs: ## Generate documentation
	@echo "Generating documentation..."
	@terraform-docs markdown table --output-file README.md modules/billing-alert/

##@ Development
dev-setup: install ## Set up development environment
	@echo "Setting up development environment..."
	@git config --local core.hooksPath .githooks
	@echo "Development environment ready!"

.DEFAULT_GOAL := help 