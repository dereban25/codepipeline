# =============================================================================
# SSM DOCUMENT RESOURCES
# =============================================================================

# SSM Document
resource "aws_ssm_document" "patch_instance_with_rollback" {
  name            = var.ssm_document_name
  document_type   = "Automation"
  document_format = "YAML"

  content = templatefile("${path.module}/ssm-document-content.yaml", {
    sns_topic_arn = aws_sns_topic.patching_notifications.arn
    s3_bucket_name = aws_s3_bucket.patching_logs.bucket
    stack_name     = var.stack_name
    account_id = data.aws_caller_identity.current.account_id
    lambda_arn = "arn:aws:iam::714087066724:role/gwf/apps/patching-groups-test/lambda-role-ssm-document"

  })

  tags = merge(var.tags, {
    Name = var.ssm_document_name
  })
} 