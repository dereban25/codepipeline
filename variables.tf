variable "environment" {
  description = "Environment name"
  type = string
}

variable "region" {
  description = "AWS region"
  type = string
}

variable "patch_prefix_name" {
  description = "Name of the patch group"
  type        = string
}

variable "sns_email_address" {
  description = "Email address for SNS subscription"
  type        = string
}

# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket for storing patching logs"
#   type        = string
# }

variable "s3_log_retention_days" {
  description = "Number of days to retain S3 log files before deletion"
  type        = number
  default     = 365
}

# =============================================================================
# TAGS CONFIGURATION
# =============================================================================

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# UNIFIED PATCH CONFIGURATION
# =============================================================================

variable "patch_configs" {
  description = "Unified configuration for all OS patch modules"
  type = map(object({
    enabled = bool
    operating_system = string
    patch_group_suffix = string
    approved_patches_compliance_level = string
    approval_rules = list(object({
      approve_after_days = number
      compliance_level = string
      enable_non_security = bool
      patch_filters = list(object({
        key = string
        values = list(string)
      }))
    }))
    tags = map(string)
  }))
}

# =============================================================================
# UNIFIED PATCH PLAN CONFIGURATION
# =============================================================================

variable "patch_plans" {
  description = "Unified configuration for all patch plan modules"
  type = map(object({
    enabled = bool
    plan_name = string
    target_instance = object({
      tag_key = string
      tag_values = list(string)
    })
    maintenance_windows = map(object({
      schedule = string
      duration = number
      cutoff = number
      reboot_option = string
      priority = number
      max_concurrency = string
      max_errors = string
      tags = map(string)
    }))
    tags = map(string)
    # Scan and Maintenance Window Configuration
    enable_scan_task = bool
    enable_maintenance_window = bool
    scan_association_schedule_mode = string
    scan_association_schedule = string
    scan_association_offset = string
    maintenance_window_schedule_mode = string
    maintenance_window_offset = string
  }))
}
