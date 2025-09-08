# =============================================================================
# UNIFIED PATCH PLAN CONFIGURATION (ALL PATCH PLANS)
# =============================================================================
# This file configures all patch plan modules using a single variable object with for_each

# Unified Patch Plan Configuration Module
module "patch_plan" {
  for_each = var.patch_plans != null ? {
    for k, v in var.patch_plans : k => v
    if v.enabled == true
  } : {}
  
  source = "./modules/patch-plan"
  
  # Common variables
  environment      = var.environment
  module_name      = each.value.plan_name
  tags            = merge(local.merged_tags, each.value.tags)

  
  # Maintenance window configuration
  enable_maintenance_window = each.value.enable_maintenance_window
  maintenance_window_schedule_mode = each.value.maintenance_window_schedule_mode
  maintenance_window_offset = each.value.maintenance_window_offset
  maintenance_window_ssm_document_name = module.base_infra.ssm_document_name
  maintenance_window_automation_execution_role_arn = module.base_infra.automation_execution_role_arn
  
  # SSM association configuration
  enable_scan_task = each.value.enable_scan_task
  scan_association_schedule_mode = each.value.scan_association_schedule_mode
  scan_association_offset = each.value.scan_association_offset
  scan_association_schedule = each.value.scan_association_schedule
  
  # Target configuration
  target_instance = each.value.target_instance
  
  # Maintenance window configuration map
  maintenance_windows = each.value.maintenance_windows
  
  # Schedule timezone
  schedule_timezone = "UTC"
} 