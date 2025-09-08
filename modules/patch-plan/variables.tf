# =============================================================================
# COMMON VARIABLES
# =============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "module_name" {
  description = "Module name for resource naming to distinguish between different instances of the module"
  type        = string
  default     = ""
}



variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# MAINTENANCE WINDOW VARIABLES
# =============================================================================

variable "maintenance_window_schedule_mode" {
  description = "How to schedule the maintenance window: 'immediate' (offset after apply) or 'configured' (use maintenance_window_schedule)"
  type        = string
  default     = "configured"
}

variable "maintenance_window_offset" {
  description = "Offset from now for immediate maintenance window start (e.g., '5m', '10m', '1h'). Used if schedule_mode is 'immediate'."
  type        = string
  default     = "5m"
}

variable "maintenance_window_schedule" {
  description = "Cron expression for maintenance window schedule (fallback when not specified in maintenance_windows map)"
  type        = string
  default     = "cron(0 2 ? * WED *)"
}

variable "maintenance_window_duration" {
  description = "Duration of maintenance window in hours"
  type        = number
  default     = 4
}

variable "maintenance_window_cutoff" {
  description = "Cutoff time before maintenance window ends"
  type        = number
  default     = 1
}

variable "reboot_option" {
  description = "Reboot option for patching. Valid values: RebootIfNeeded, NoReboot, RebootAsDefault"
  type        = string
  default     = "RebootIfNeeded"
}

variable "maintenance_window_ssm_document_name" {
  description = "Name of the SSM document to use for maintenance window patching"
  type        = string
  default     = "PatchInstanceWithRollback"
}

variable "maintenance_window_automation_execution_role_arn" {
  description = "ARN of the automation execution role from base-infra module for maintenance windows"
  type        = string
}

variable "target_instance_tag_key" {
  description = "Tag key to use for targeting instances. Example: 'Patch Group' or 'SSMGroup'"
  type        = string
  default     = "Patch Group"
}

variable "target_instance_tag_value" {
  description = "Tag value to use for targeting instances. Defaults to patch_prefix_name."
  type        = string
  default     = ""
}

variable "target_instance" {
  description = "Object to define target instances with multiple targeting options"
  type = object({
    tag_key = string
    tag_values = list(string)
  })
  default = null
}

variable "enable_maintenance_window" {
  description = "Whether to create maintenance windows for install operations"
  type        = bool
  default     = true
}

variable "enable_scan_task" {
  description = "Whether to create the scan task"
  type        = bool
  default     = true
}

variable "enable_install_task" {
  description = "Whether to create the install task"
  type        = bool
  default     = true
}

variable "scan_association_schedule" {
  description = "Cron expression for scan association schedule"
  type        = string
  default     = "cron(0 1 ? * TUE *)"
}

variable "scan_association_schedule_mode" {
  description = "How to schedule the scan association: 'immediate' (offset after apply) or 'configured' (use scan_association_schedule)"
  type        = string
  default     = "configured"
}

variable "scan_association_offset" {
  description = "Offset from now for immediate scan association start (e.g., '5m', '10m', '1h'). Used if schedule_mode is 'immediate'."
  type        = string
  default     = "5m"
}

variable "maintenance_windows" {
  description = "Map of maintenance window configurations (e.g. config)"
  type = map(object({
    schedule      = string
    duration      = number
    cutoff        = number
    reboot_option = string  # 'RebootIfNeeded' or 'NoReboot'
    priority      = number
    tags          = map(string)
    max_concurrency = string  # Can be number (e.g., '5') or percentage (e.g., '50%')
    max_errors      = string  # Can be number (e.g., '5') or percentage (e.g., '50%')
  }))
  default = {}
}

variable "schedule_timezone" {
  description = "Timezone for the maintenance window (e.g., 'UTC', 'Europe/Berlin', 'America/New_York'). Default is 'UTC'."
  type        = string
  default     = "UTC"
}

 