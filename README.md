# Slate Infrastructure

Modern AWS infrastructure management using Terragrunt and Terraform.

## Overview

This repository contains the complete infrastructure-as-code setup for managing AWS resources using:
- **Terragrunt** for DRY configuration and state management
- **Terraform** for resource provisioning (latest version >= 1.6.0)
- **GitHub Actions** for CI/CD
- **Pre-commit hooks** for code quality

## Structure

```
├── root.hcl                 # Root terragrunt configuration
├── billing-alert/           # Billing alert configuration
├── modules/                 # Reusable terraform modules
│   └── billing-alert/       # Billing alert module
├── .github/                 # GitHub Actions workflows
├── scripts/                 # Utility scripts
├── Makefile                 # Command shortcuts
└── README.md                # This file
```

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.10.0 (required for S3 native state locking)
- Terragrunt >= 0.50.0
- Pre-commit hooks installed

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd slate-tf
   ```

2. **Install dependencies**
   ```bash
   make install
   ```

3. **Set up the state backend**
   ```bash
   ./scripts/setup-state-backend.sh
   ```

4. **Configure billing alerts**
   Edit `billing-alert/terragrunt.hcl` and update the email addresses:
   ```hcl
   alert_emails = [
     "your-email@company.com",
     "finance@company.com"
   ]
   ```

5. **Initialize and deploy the billing alerts**
   ```bash
   make init           # Initialize terragrunt configurations
   make plan-billing   # Review the plan
   make apply-billing  # Apply the changes
   ```

## State Management

- **S3 Bucket**: `slate-infra` (us-east-1)
- **State Locking**: S3 native locking
- **Encryption**: AES256 at rest
- **Versioning**: Enabled on S3 bucket

This repository uses Terraform v1.10.0+ with S3 native state locking. Lock files are created as `.tflock` files alongside the state file during operations.

## Available Commands

Run `make help` to see all available commands:

```bash
make help           # Show all available commands
make install        # Install dependencies
make check          # Run formatting and validation
make init           # Initialize all terragrunt configurations
make plan           # Plan all infrastructure changes
make apply          # Apply all infrastructure changes
make plan-billing   # Plan billing alert changes only
make apply-billing  # Apply billing alert changes only
make clean          # Clean up temporary files
```

## First Component: Billing Alerts

The billing alert module creates:
- **SNS Topic** for notifications
- **CloudWatch Alarms** for billing thresholds
- **Email Subscriptions** for alerts

Default thresholds:
- Warning: $50
- Critical: $80
- Total Account: $100

## Development Workflow

1. Create feature branch
2. Make changes to infrastructure
3. Run `make check` to validate
4. Run `make plan` to preview changes
5. Create PR for review
6. Merge to main for automatic deployment

## Security Features

- Pre-commit hooks for security scanning
- Checkov security analysis in CI
- State encryption at rest
- Least privilege IAM policies
- No hardcoded secrets

## GitHub Actions Setup

To enable CI/CD, add these secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

The workflow will:
- Validate Terraform on PRs
- Run security scans
- Auto-deploy on merge to main

## Important Notes

- **Billing metrics are only available in us-east-1**
- **Email subscriptions require manual confirmation**
- **State files are encrypted and versioned**
- **Requires Terraform v1.10.0+ for S3 native locking**

## Troubleshooting

### Common Issues

1. **"No such bucket" error**: Run `./scripts/setup-state-backend.sh`
2. **Permission denied**: Check AWS credentials and permissions
3. **State locked**: Someone else is running Terraform, wait or use `terragrunt force-unlock`

### Getting Help

- Check the `modules/*/README.md` for module-specific documentation
- Review GitHub Actions logs for CI/CD issues
- Validate AWS permissions for your user/role



## Next Steps

After setting up billing alerts, consider adding:
- VPC and networking resources
- Security groups and NACLs
- EC2 instances or container services
- RDS or other data services
- CloudFront distributions
- Route53 DNS records

## Support

For questions or issues, please create an issue in this repository. 