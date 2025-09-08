# =============================================================================
# Base Infrastructure Module Outputs
# =============================================================================

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.base_infra.s3_bucket_arn
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.base_infra.s3_bucket_name
}

output "s3_bucket_id" {
  description = "ID of the created S3 bucket"
  value       = module.base_infra.s3_bucket_id
}

output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.base_infra.sns_topic_arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = module.base_infra.sns_topic_name
}

output "ssm_document_name" {
  description = "Name of the created SSM document"
  value       = module.base_infra.ssm_document_name
}

output "ssm_document_arn" {
  description = "ARN of the created SSM document"
  value       = module.base_infra.ssm_document_arn
}

output "ssm_instance_role_arn" {
  description = "ARN of the SSM Instance Role"
  value       = module.base_infra.ssm_instance_role_arn
}

output "ssm_instance_role_name" {
  description = "Name of the SSM Instance Role"
  value       = module.base_infra.ssm_instance_role_name
}

output "ssm_instance_profile_arn" {
  description = "ARN of the SSM Instance Profile"
  value       = module.base_infra.ssm_instance_profile_arn
}

output "ssm_instance_profile_name" {
  description = "Name of the SSM Instance Profile"
  value       = module.base_infra.ssm_instance_profile_name
}

output "automation_execution_role_arn" {
  description = "ARN of the Automation Execution Role"
  value       = module.base_infra.automation_execution_role_arn
}

output "automation_execution_role_name" {
  description = "Name of the Automation Execution Role"
  value       = module.base_infra.automation_execution_role_name
}

# =============================================================================
# UNIFIED PATCH CONFIGURATION OUTPUTS
# =============================================================================

# Output all patch baseline IDs
output "patch_baseline_ids" {
  description = "IDs of all created patch baselines"
  value = {
    for os, module in module.patch_config : os => module.patch_baseline_id
  }
}

# Output all patch baseline ARNs
output "patch_baseline_arns" {
  description = "ARNs of all created patch baselines"
  value = {
    for os, module in module.patch_config : os => module.patch_baseline_arn
  }
}

# Output all patch group names
output "patch_group_names" {
  description = "Names of all created patch groups"
  value = {
    for os, module in module.patch_config : os => module.patch_group_name
  }
}

# =============================================================================
# UNIFIED PATCH PLAN OUTPUTS
# =============================================================================

# Output all maintenance window IDs
output "patch_plan_maintenance_window_ids" {
  description = "IDs of all created maintenance windows"
  value = {
    for plan, module in module.patch_plan : plan => module.maintenance_window_id
  }
}

# Output all maintenance window target IDs
output "patch_plan_maintenance_window_target_ids" {
  description = "IDs of all created maintenance window targets"
  value = {
    for plan, module in module.patch_plan : plan => module.maintenance_window_target_id
  }
}

# Output all maintenance window task IDs
output "patch_plan_maintenance_window_task_ids" {
  description = "IDs of all created maintenance window tasks"
  value = {
    for plan, module in module.patch_plan : plan => module.maintenance_window_task_id
  }
}

# Output all SSM association IDs
output "patch_plan_ssm_association_ids" {
  description = "IDs of all created SSM associations"
  value = {
    for plan, module in module.patch_plan : plan => module.ssm_association_id
  }
}

# Output all SSM association names
output "patch_plan_ssm_association_names" {
  description = "Names of all created SSM associations"
  value = {
    for plan, module in module.patch_plan : plan => module.ssm_association_name
  }
}




