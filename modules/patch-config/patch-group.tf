# =============================================================================
# PATCH GROUP RESOURCES
# =============================================================================

# Patch Group Resource
resource "aws_ssm_patch_group" "main" {
  baseline_id = aws_ssm_patch_baseline.main.id
  patch_group = var.patch_group_name
} 