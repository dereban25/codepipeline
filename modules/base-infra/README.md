# Base Infrastructure Module

This Terraform module consolidates the core infrastructure components needed for AWS Systems Manager patching automation across multiple accounts. It combines S3 bucket, SNS topic, SSM document, and IAM roles into a single, cohesive module.

## Module Structure

```
terraform/modules/base-infra/
├── main.tf                    # Data sources
├── s3.tf                      # S3 bucket resources
├── sns.tf                     # SNS topic resources
├── ssm.tf                     # SSM document resources
├── iam.tf                     # IAM roles and policies
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── README.md                  # This documentation
└── ssm-document-content.yaml  # SSM document template
```

## Resources Created

### S3 Bucket (`s3.tf`)
- **S3 Bucket**: For storing SSM document execution logs
- **Versioning**: Enabled for data protection
- **Encryption**: Server-side encryption with AES256
- **Lifecycle Policy**: Automated data lifecycle management
- **Public Access**: Completely blocked for security
- **Bucket Policy**: Restricts access to current account

### SNS Topic (`sns.tf`)
- **SNS Topic**: For patching notifications
- **Email Subscription**: Automatic email subscription
- **Topic Policy**: Account-based access control

### SSM Document (`ssm.tf`)
- **Automation Document**: PatchInstanceWithRollback document
- **YAML Format**: Uses templatefile for dynamic content
- **Integration**: Automatically references S3 bucket and SNS topic

### IAM Roles (`iam.tf`)
- **SSM Instance Role**: For EC2 instances to use Systems Manager
- **SSM Instance Profile**: Attached to the SSM role
- **Automation Execution Role**: For SSM automation execution with comprehensive permissions

## Usage

```hcl
module "base_infra" {
  source = "./modules/base-infra"

  # Required variables
  environment        = "production"
  s3_bucket_name     = "my-patching-logs-bucket"
  sns_email_address  = "admin@company.com"
  
  # Optional variables with defaults
  s3_log_retention_days = 365
  sns_topic_name        = "patching-notifications"
  sns_display_name      = "Patching Notifications"
  ssm_document_name     = "PatchInstanceWithRollback"
  stack_name            = "PatchingStack"
  ssm_instance_profile_role = "AWSEC2RoleForSSM"
  automation_execution_role  = "CustomSystemsManagerAutomationExecutionRole"
  
  tags = {
    Environment = "production"
    Purpose     = "PatchManagement"
    Owner       = "DevOps"
  }
}
```

## Required Variables

- `environment`: Environment name (e.g., "production", "staging", "test")
- `s3_bucket_name`: Name of the S3 bucket for storing patching logs
- `sns_email_address`: Email address for SNS subscription

## Optional Variables

- `s3_log_retention_days`: Number of days to retain S3 log files (default: 365)
- `sns_topic_name`: Name of the SNS topic (default: "patching-notifications")
- `sns_display_name`: Display name for the SNS topic (default: "Patching Notifications")
- `ssm_document_name`: Name of the SSM automation document (default: "PatchInstanceWithRollback")
- `stack_name`: Stack name for resource naming (default: "PatchingStack")
- `ssm_instance_profile_role`: Name for the SSM instance role (default: "AWSEC2RoleForSSM")
- `automation_execution_role`: Name for the automation execution role (default: "CustomSystemsManagerAutomationExecutionRole")
- `tags`: Map of tags to apply to all resources (default: {})

## Outputs

### S3 Bucket
- `s3_bucket_arn`: ARN of the created S3 bucket
- `s3_bucket_name`: Name of the created S3 bucket
- `s3_bucket_id`: ID of the created S3 bucket

### SNS Topic
- `sns_topic_arn`: ARN of the created SNS topic
- `sns_topic_name`: Name of the created SNS topic

### SSM Document
- `ssm_document_name`: Name of the created SSM document
- `ssm_document_arn`: ARN of the created SSM document

### IAM Roles
- `ssm_instance_role_arn`: ARN of the SSM Instance Role
- `ssm_instance_role_name`: Name of the SSM Instance Role
- `ssm_instance_profile_arn`: ARN of the SSM Instance Profile
- `ssm_instance_profile_name`: Name of the SSM Instance Profile
- `automation_execution_role_arn`: ARN of the Automation Execution Role
- `automation_execution_role_name`: Name of the Automation Execution Role

## Security Features

- **S3 Security**: Encryption, versioning, public access blocking, lifecycle policies
- **SNS Security**: Account-based topic policies
- **IAM Security**: Least privilege principles, proper assume role policies
- **SSM Security**: Secure document execution with proper permissions

## Dependencies

- AWS Provider configured
- Proper AWS credentials and permissions
- SSM document content file (`ssm-document-content.yaml`)

## Notes

- This module is designed to be deployed once per environment
- All resources are properly tagged for cost tracking and organization
- The SSM document automatically references the created S3 bucket and SNS topic
- IAM roles include comprehensive permissions for patching automation
- S3 bucket includes lifecycle policies for cost optimization
- Resources are organized in separate files for better maintainability 