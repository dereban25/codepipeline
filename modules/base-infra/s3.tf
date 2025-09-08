# =============================================================================
# S3 BUCKET RESOURCES
# =============================================================================

# S3 Bucket for storing SSM document execution logs
resource "aws_s3_bucket" "patching_logs" {
  bucket = var.s3_bucket_name

  tags = var.tags
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "patching_logs" {
  bucket = aws_s3_bucket.patching_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy to allow PutObject from the current AWS account
resource "aws_s3_bucket_policy" "patching_logs" {
  bucket = aws_s3_bucket.patching_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPutObjectFromCurrentAccount"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.patching_logs.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "patching_logs" {
  bucket = aws_s3_bucket.patching_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle configuration for log retention
resource "aws_s3_bucket_lifecycle_configuration" "patching_logs" {
  bucket = aws_s3_bucket.patching_logs.id

  rule {
    id     = "log_retention"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = var.s3_log_retention_days
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
} 