# =============================================================================
# MAINTENANCE WINDOW RESOURCES (INSTALL ONLY)
# =============================================================================

resource "aws_ssm_maintenance_window" "config" {
  count = var.enable_maintenance_window ? 1 : 0
  
  name              = "maintenance-window${var.module_name != "" ? "-${var.module_name}" : ""}-install-${var.environment}"
  description       = "Install maintenance window for ${var.module_name != "" ? "${var.module_name}" : ""} patching in ${var.environment}"
  schedule          = local.maintenance_window_schedule
  duration          = var.maintenance_windows["config"].duration
  cutoff            = var.maintenance_windows["config"].cutoff
  allow_unassociated_targets = false
  schedule_timezone = var.schedule_timezone
  tags = merge(var.tags, var.maintenance_windows["config"].tags, {
    Name = "maintenance-window${var.module_name != "" ? "-${var.module_name}" : ""}-install-${var.environment}"
    Operation = "Install"
  })
}

resource "aws_ssm_maintenance_window_target" "config" {
  count = var.enable_maintenance_window ? 1 : 0
  
  window_id     = aws_ssm_maintenance_window.config[0].id
  name          = "target${var.module_name != "" ? "-${var.module_name}" : ""}-install-${var.environment}"
  description   = "Target for install ${var.module_name != "" ? "${var.module_name}" : ""} patching in ${var.environment}"
  resource_type = "INSTANCE"
  targets {
    key    = "tag:${var.target_instance.tag_key}"
    values = var.target_instance.tag_values
    }
}

resource "aws_ssm_maintenance_window_task" "config" {
  count = var.enable_maintenance_window ? 1 : 0
  
  window_id        = aws_ssm_maintenance_window.config[0].id
  name             = "task${var.module_name != "" ? "-${var.module_name}" : ""}-install-${var.environment}"
  description      = "Install task for ${var.module_name != "" ? "${var.module_name}" : ""} patching in ${var.environment}"
  task_type        = "AUTOMATION"
  task_arn         = var.maintenance_window_ssm_document_name
  priority         = var.maintenance_windows["config"].priority
  service_role_arn = var.maintenance_window_automation_execution_role_arn
  max_concurrency  = var.maintenance_windows["config"].max_concurrency
  max_errors       = var.maintenance_windows["config"].max_errors
  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.config[0].id]
  }
  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"
      parameter {
        name   = "InstanceId"
        values = ["{{TARGET_ID}}"]
      }
      parameter {
        name   = "RebootOption"
        values = [var.maintenance_windows["config"].reboot_option]
      }
      parameter {
        name = "Operation"
        values = ["Install"]
      }
    }
  }
} 