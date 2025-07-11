#!/bin/bash

# Setup script for Terraform state backend
# This script configures the S3 bucket for Terraform state with native locking

set -e

# Configuration
BUCKET_NAME="slate-infra"
AWS_REGION="us-east-1"

echo "Setting up Terraform state backend with S3 native locking..."

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if S3 bucket exists
echo "Checking if S3 bucket '$BUCKET_NAME' exists..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "✅ S3 bucket '$BUCKET_NAME' exists"
else
    echo "❌ S3 bucket '$BUCKET_NAME' does not exist"
    echo "Please create the bucket first with:"
    echo "aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION"
    exit 1
fi

# Enable S3 bucket versioning
echo "Enabling S3 bucket versioning..."
aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

# Enable S3 bucket encryption
echo "Enabling S3 bucket encryption..."
aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block public access
echo "Blocking public access to S3 bucket..."
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo ""
echo "🎉 Terraform state backend setup completed!"
echo ""
echo "Configuration:"
echo "  S3 Bucket: $BUCKET_NAME"
echo "  Region: $AWS_REGION"
echo "  Locking: S3 native (use_lockfile = true)"
echo "  Encryption: AES256"
echo "  Versioning: Enabled"
echo ""
echo "You can now run 'make init' to initialize your Terraform configuration." 