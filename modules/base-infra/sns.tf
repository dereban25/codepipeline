# =============================================================================
# SNS TOPIC RESOURCES
# =============================================================================

# Create the SNS Topic
resource "aws_sns_topic" "patching_notifications" {
  name         = var.sns_topic_name
  display_name = var.sns_display_name

  tags = merge(var.tags, {
    Name = var.sns_topic_name
  })
}

# Subscribe an email address to the SNS Topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.patching_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_email_address
}

# Attach a policy to the SNS Topic
resource "aws_sns_topic_policy" "main" {
  arn = aws_sns_topic.patching_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.patching_notifications.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
} 