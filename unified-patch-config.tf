# =============================================================================
# UNIFIED PATCH CONFIGURATION (ALL OS TYPES)
# =============================================================================
# This file configures all OS patch modules using a single variable object with for_each

# Unified Patch Configuration Module
module "patch_config" {
  for_each = var.patch_configs != null ? {
    for k, v in var.patch_configs : k => v
    if v.enabled == true
  } : {}
  
  source = "./modules/patch-config"
  
  # Required variables
  environment      = var.environment
  patch_group_name = "${var.patch_prefix_name}-${each.value.patch_group_suffix}"
  
  # Patch baseline configuration
  operating_system = each.value.operating_system
  approved_patches_compliance_level = each.value.approved_patches_compliance_level
  approval_rules = each.value.approval_rules
  
  # Use merged tags from main configuration
  tags = merge(local.merged_tags, each.value.tags)
} 

