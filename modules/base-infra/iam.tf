# =============================================================================
# IAM ROLES RESOURCES
# =============================================================================

# SSM Instance Role for EC2
resource "aws_iam_role" "ssm_instance_role" {
  name = var.ssm_instance_profile_role
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gwf/boundaries/apps/GwfAppPermissionsBoundaryWithoutIAM"
  path = "/gwf/apps/patching-groups-test/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach managed policies to SSM Instance Role
resource "aws_iam_role_policy_attachment" "ssm_instance_role_ssm_policy" {
  role       = aws_iam_role.ssm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ssm_instance_role_ssm_core_policy" {
  role       = aws_iam_role.ssm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# SSM Instance Profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = var.ssm_instance_profile_role
  role = aws_iam_role.ssm_instance_role.name
  path = "/gwf/apps/patching-groups-test/"

  tags = var.tags
}

# Custom Systems Manager Automation Execution Role
resource "aws_iam_role" "automation_execution_role" {
  name = var.automation_execution_role
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gwf/boundaries/apps/GwfAppPermissionsBoundaryWithoutIAM"
  path = "/gwf/apps/patching-groups-test/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ssm.amazonaws.com",
            "cloudformation.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = [
              "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:automation-execution/*",
              "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:maintenancewindow/*",
              "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:document/*"
            ]
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Inline policy for Automation Execution Role
resource "aws_iam_role_policy" "automation_execution_inline_policy" {
  name = "Custom-SystemsManager-AutomationExecutionRoleInlinePolicy"
  role = aws_iam_role.automation_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:CreateSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeVolumes",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshotAttribute"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAM"
        Effect = "Allow"
        Action = [
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:TagRole",
				  "iam:TagPolicy",
				  "iam:TagUser"
        ]
        Resource = "*"
      },
      {
        Sid    = "PassRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          "arn:aws:iam::714087066724:role/PatchInstanceWithRollbackStack089465ac-LambdaRole-1RUL0BYNXVF6",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/gwf/apps/patching-groups-test/${var.automation_execution_role}*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.stack_name}*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/gwf/apps/patching-groups-test/lambda-role-ssm-document"
        ]
      },
      {
        Sid    = "Lambda"
        Effect = "Allow"
        Action = [
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:GetRuntimeManagementConfig",
          "lambda:CreateFunction",
          "lambda:InvokeFunction",
          "lambda:GetFunctionCodeSigningConfig"
        ]
        Resource = "*"
      },
      {
        Sid    = "SSM"
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:DescribeInstanceInformation",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssm:StartAutomationExecution",
          "ssm:DescribeAutomationExecutions",
          "ssm:GetAutomationExecution",
          "ssm:DescribeAutomationStepExecutions"
        ]
        Resource = "*"
      },
      {
        Sid    = "SNS"
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.patching_notifications.arn
      },
      {
        Sid    = "CloudFormation"
        Effect = "Allow"
        Action = [
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.patching_logs.arn}/*"
        ]
      },
      {
        Sid    = "ResourceGroupTaggingAPI"
        Effect = "Allow"
        Action = [
          "tag:GetResources"
        ]
        Resource = "*"
      },
      {
        Sid    = "AWSResourceGroups"
        Effect = "Allow"
        Action = [
          "resource-groups:ListGroupResources"
        ]
        Resource = "*"
      }
    ]
  })
} 

# Custom Systems Manager Automation Execution Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role-ssm-document"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gwf/boundaries/apps/GwfAppPermissionsBoundaryWithoutIAM"
  path = "/gwf/apps/patching-groups-test/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Inline policy for Automation Execution Role
resource "aws_iam_role_policy" "lambda_role_inline_policy" {
  name = "Custom-Lambda-SSM-Document"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2"
        Effect = "Allow"
        Action: [
          "ec2:CreateSnapshot", 
          "ec2:DeleteSnapshot", 
          "ec2:DescribeInstances", 
          "ec2:DescribeSnapshots", 
          "ec2:DescribeVolumes", 
          "ec2:DescribeInstanceAttribute", 
          "ec2:CreateVolume", 
          "ec2:AttachVolume", 
          "ec2:DetachVolume", 
          "ec2:StartInstances", 
          "ec2:StopInstances", 
          "ssm:ListCommands", 
          "ssm:ListComplianceItems", 
          "s3:PutObject", 
          "s3:PutObjectAcl", 
          "cloudwatch:*", 
          "logs:CreateLogGroup", 
          "logs:CreateLogStream", 
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Sid    = "PassRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/gwf/apps/patching-groups-test/${var.automation_execution_role}*",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.stack_name}*"
        ]
      }
    ]
  })
}