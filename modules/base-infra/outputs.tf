# =============================================================================
# S3 BUCKET OUTPUTS
# =============================================================================

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.patching_logs.arn
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.patching_logs.bucket
}

output "s3_bucket_id" {
  description = "ID of the created S3 bucket"
  value       = aws_s3_bucket.patching_logs.id
}

# =============================================================================
# SNS TOPIC OUTPUTS
# =============================================================================

output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.patching_notifications.arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = aws_sns_topic.patching_notifications.name
}

# =============================================================================
# SSM DOCUMENT OUTPUTS
# =============================================================================

output "ssm_document_name" {
  description = "Name of the created SSM document"
  value       = aws_ssm_document.patch_instance_with_rollback.name
}

output "ssm_document_arn" {
  description = "ARN of the created SSM document"
  value       = aws_ssm_document.patch_instance_with_rollback.arn
}

# =============================================================================
# IAM ROLES OUTPUTS
# =============================================================================

output "ssm_instance_role_arn" {
  description = "ARN of the SSM Instance Role"
  value       = aws_iam_role.ssm_instance_role.arn
}

output "ssm_instance_role_name" {
  description = "Name of the SSM Instance Role"
  value       = aws_iam_role.ssm_instance_role.name
}

output "ssm_instance_profile_arn" {
  description = "ARN of the SSM Instance Profile"
  value       = aws_iam_instance_profile.ssm_instance_profile.arn
}

output "ssm_instance_profile_name" {
  description = "Name of the SSM Instance Profile"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}

output "automation_execution_role_arn" {
  description = "ARN of the Automation Execution Role"
  value       = aws_iam_role.automation_execution_role.arn
}

output "automation_execution_role_name" {
  description = "Name of the Automation Execution Role"
  value       = aws_iam_role.automation_execution_role.name
} 