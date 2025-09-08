# =============================================================================
# SSM ASSOCIATION RESOURCES FOR SCAN OPERATIONS
# =============================================================================

# SSM Association for patch scanning
resource "aws_ssm_association" "patch_scan" {
  count = var.enable_scan_task ? 1 : 0
  
  name = "AWS-RunPatchBaseline"
  
  targets {
      key    = "tag:${var.target_instance.tag_key}"
      values = var.target_instance.tag_values
    }

  
  parameters = {
    Operation = "Scan"
    RebootOption = "NoReboot"
  }
  apply_only_at_cron_interval = true
  schedule_expression = local.scan_association_schedule
  
  association_name = "ssm-association${var.module_name != "" ? "-${var.module_name}" : ""}-scan-${var.environment}"
  
  tags = merge(var.tags, {
    Name = "ssm-association${var.module_name != "" ? "-${var.module_name}" : ""}-scan-${var.environment}"
    Operation = "Scan"
  })
} 