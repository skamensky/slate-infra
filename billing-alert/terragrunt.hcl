# Billing Alert Terragrunt Configuration

# Include the root terragrunt configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Configure the terraform source
terraform {
  source = "../modules/billing-alert"
}

# Configure inputs specific to billing alerts
inputs = {
  # Project name
  project_name = "slate-infra"
  
  # Email addresses for billing alerts
  alert_emails = [
    "jake@slatecinema.com",
    "shmuelkamensky@gmail.com"
  ]
  
  # Total billing threshold in USD
  total_billing_threshold = 15
  
  # Billing thresholds by category (adjusted for $15 budget)
  billing_thresholds = {
    warning  = 5   # 33% of budget
    critical = 10  # 67% of budget
  }
  
  # Additional tags
  tags = {
    Component = "billing-alert"
    Owner     = "platform-team"
    Budget    = "15"
  }
} 