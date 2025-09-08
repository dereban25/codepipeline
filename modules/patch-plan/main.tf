# =============================================================================
# DATA SOURCES
# =============================================================================

# Data source to get current account ID
data "aws_caller_identity" "current" {}

# =============================================================================
# LOCALS
# =============================================================================

locals {
  # Calculate the immediate start time for scan association in UTC
  scan_immediate_start_time = timeadd(timestamp(), var.scan_association_offset)
  
  # Generate cron expression for immediate scan mode (one-time execution)
  scan_immediate_cron = "cron(${formatdate("m", local.scan_immediate_start_time)} ${formatdate("h", local.scan_immediate_start_time)} * * ? *)"
  
  # Calculate the immediate start time for maintenance window in UTC
  immediate_start_time = timeadd(timestamp(), var.maintenance_window_offset)
  
  # Generate cron expression for immediate mode (one-time execution)
  # AWS Cron Format: cron(minute hour day-of-month month day-of-week year)
  # For one-time execution, we use specific day-of-month and month, ? for day-of-week
  # This creates a more specific one-time cron expression
  immediate_cron = "cron(${formatdate("m", local.immediate_start_time)} ${formatdate("h", local.immediate_start_time)} ${formatdate("D", local.immediate_start_time)} ${formatdate("M", local.immediate_start_time)} ? *)"
  
  # Scan association schedule - use immediate cron if immediate mode, otherwise use configured schedule
  scan_association_schedule = var.scan_association_schedule_mode == "immediate" ? local.scan_immediate_cron : var.scan_association_schedule
  
  # Use schedule from maintenance_windows map, fallback to configured schedule if not present
  # For immediate mode, use the generated cron expression
  maintenance_window_schedule = var.maintenance_window_schedule_mode == "immediate" ? local.immediate_cron : (var.maintenance_windows["config"].schedule != null ? var.maintenance_windows["config"].schedule : var.maintenance_window_schedule)
} 