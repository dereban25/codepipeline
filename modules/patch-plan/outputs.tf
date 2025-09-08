# =============================================================================
# MAINTENANCE WINDOW OUTPUTS
# =============================================================================

output "maintenance_window_id" {
  description = "ID of the maintenance window"
  value       = var.enable_maintenance_window ? aws_ssm_maintenance_window.config[0].id : null
}

output "maintenance_window_target_id" {
  description = "ID of the maintenance window target"
  value       = var.enable_maintenance_window ? aws_ssm_maintenance_window_target.config[0].id : null
}

output "maintenance_window_task_id" {
  description = "ID of the maintenance window task"
  value       = var.enable_maintenance_window ? aws_ssm_maintenance_window_task.config[0].id : null
}

# =============================================================================
# SSM ASSOCIATION OUTPUTS
# =============================================================================

output "ssm_association_id" {
  description = "ID of the SSM association for patch scanning"
  value       = var.enable_scan_task ? aws_ssm_association.patch_scan[0].association_id : null
}

output "ssm_association_name" {
  description = "Name of the SSM association for patch scanning"
  value       = var.enable_scan_task ? aws_ssm_association.patch_scan[0].association_name : null
} 