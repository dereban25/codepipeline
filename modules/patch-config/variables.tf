# =============================================================================
# COMMON VARIABLES
# =============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "patch_group_name" {
  description = "Name of the patch group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# PATCH BASELINE VARIABLES
# =============================================================================

variable "operating_system" {
  description = "Operating system for the patch baseline"
  type        = string
  default     = "AMAZON_LINUX_2"
}

variable "approval_rules" {
  description = "List of approval rules for the patch baseline"
  type = list(object({
    approve_after_days = number
    compliance_level   = string
    enable_non_security = bool
    patch_filters = list(object({
      key    = string
      values = list(string)
    }))
  }))
  default = []
}

variable "approved_patches" {
  description = "List of explicitly approved patches"
  type        = list(string)
  default     = []
}

variable "rejected_patches" {
  description = "List of explicitly rejected patches"
  type        = list(string)
  default     = []
}

variable "approved_patches_compliance_level" {
  description = "Compliance level for approved patches. Valid values: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED"
  type        = string
  default     = "HIGH"
  validation {
    condition     = contains(["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "UNSPECIFIED"], var.approved_patches_compliance_level)
    error_message = "approved_patches_compliance_level must be one of: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED."
  }
} 