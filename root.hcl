# Root terragrunt configuration
# This file contains the common configuration for all environments

# Configure remote state with S3 native locking
remote_state {
  backend = "s3"
  config = {
    bucket         = "slate-infra"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
    # S3 native state locking (Terraform v1.10.0+)
    use_lockfile   = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure provider requirements
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      Project    = "slate-infra"
      ManagedBy  = "terragrunt"
      Repository = "slate-tf"
    }
  }
}
EOF
}

# Prevent destruction of critical resources
prevent_destroy = true 