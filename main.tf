# Base Infrastructure Module
# This module consolidates S3 bucket, SNS topic, SSM document, and IAM roles
locals {
  s3_bucket_name   = "patching-ec2-account-${data.aws_caller_identity.current.account_id}-${var.region}"
  
  # Merge default tags with user-provided tags from tfvars
  default_tags = {
    Purpose     = "PatchManagement"
    Environment = var.environment
  }
  
  # Merge default tags with user-provided tags, with user tags taking precedence
  merged_tags = merge(local.default_tags, var.tags)
}

module "base_infra" {
  source = "./modules/base-infra"
  
  # Required variables
  environment       = var.environment
  s3_bucket_name    = local.s3_bucket_name
  sns_email_address = var.sns_email_address
  
  # Optional variables with defaults
  s3_log_retention_days = var.s3_log_retention_days
  sns_topic_name        = "sns-${var.patch_prefix_name}-${var.environment}"
  sns_display_name      = "Patching Notifications - ${var.patch_prefix_name}-${var.environment}"
  ssm_document_name     = "PatchInstanceWithRollback-${var.patch_prefix_name}-${var.environment}"
  stack_name            = "PatchingStack-${var.patch_prefix_name}-${var.environment}"
  ssm_instance_profile_role = "AWSEC2RoleForSSM-${var.patch_prefix_name}-${var.environment}"
  automation_execution_role  = "SystemsManagerExecutionRole-${var.patch_prefix_name}-${var.environment}"
  
  tags = local.merged_tags
}

