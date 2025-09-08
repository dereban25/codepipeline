# =============================================================================
# OUTPUTS
# =============================================================================

output "patch_baseline_id" {
  description = "ID of the created patch baseline"
  value       = aws_ssm_patch_baseline.main.id
}

output "patch_baseline_arn" {
  description = "ARN of the created patch baseline"
  value       = aws_ssm_patch_baseline.main.arn
}

output "patch_baseline_name" {
  description = "Name of the created patch baseline"
  value       = aws_ssm_patch_baseline.main.name
}

# =============================================================================
# PATCH GROUP OUTPUTS
# =============================================================================

output "patch_group_name" {
  description = "Name of the created patch group"
  value       = aws_ssm_patch_group.main.patch_group
} 