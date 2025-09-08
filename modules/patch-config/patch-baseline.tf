# =============================================================================
# PATCH BASELINE RESOURCES
# =============================================================================

# Patch Baseline Resource
resource "aws_ssm_patch_baseline" "main" {
  name             = "patch-baseline-${var.patch_group_name}"
  description      = "Patch baseline for group ${var.patch_group_name}"
  operating_system = var.operating_system
  
  approved_patches          = var.approved_patches
  rejected_patches         = var.rejected_patches
  approved_patches_compliance_level = var.approved_patches_compliance_level
  
  dynamic "approval_rule" {
    for_each = var.approval_rules
    content {
      approve_after_days  = approval_rule.value.approve_after_days
      compliance_level    = approval_rule.value.compliance_level
      enable_non_security = approval_rule.value.enable_non_security
      
      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_filters
        content {
          key    = patch_filter.value.key
          values = patch_filter.value.values
        }
      }
    }
  }
  
  tags = merge(var.tags, {
    Name = "patch-baseline-${var.patch_group_name}"
  })
}
