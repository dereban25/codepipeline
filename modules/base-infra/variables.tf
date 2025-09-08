# =============================================================================
# S3 BUCKET VARIABLES
# =============================================================================

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing patching logs"
  type        = string
}

variable "s3_log_retention_days" {
  description = "Number of days to retain S3 log files before deletion"
  type        = number
  default     = 365
}

# =============================================================================
# SNS TOPIC VARIABLES
# =============================================================================

variable "sns_topic_name" {
  description = "Name of the SNS topic for patching notifications"
  type        = string
  default     = "patching-notifications"
}

variable "sns_display_name" {
  description = "Display name for the SNS topic"
  type        = string
  default     = "Patching Notifications"
}

variable "sns_email_address" {
  description = "Email address for SNS subscription"
  type        = string
}

# =============================================================================
# SSM DOCUMENT VARIABLES
# =============================================================================

variable "ssm_document_name" {
  description = "Name of the SSM automation document"
  type        = string
  default     = "PatchInstanceWithRollback"
}

variable "stack_name" {
  description = "Stack name for resource naming"
  type        = string
  default     = "PatchingStack"
}

# =============================================================================
# IAM ROLES VARIABLES
# =============================================================================

variable "ssm_instance_profile_role" {
  description = "Name for the IAM role for SSM for EC2"
  type        = string
  default     = "AWSEC2RoleForSSM"
}

variable "automation_execution_role" {
  description = "Name for the IAM role for SSM Patching Automation"
  type        = string
  default     = "CustomSystemsManagerAutomationExecutionRole"
}

# =============================================================================
# COMMON VARIABLES
# =============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 