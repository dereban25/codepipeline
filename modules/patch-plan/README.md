# Patch Plan Module

This module creates maintenance windows and SSM associations for patch planning and execution.

## Features

- **Maintenance Windows**: Creates SSM maintenance windows for patch installation
- **SSM Associations**: Creates SSM associations for patch scanning
- **Flexible Scheduling**: Supports both immediate and configured scheduling modes
- **Multi-OS Support**: Works with different operating systems

## Usage

```hcl
module "patch_plan" {
  source = "./modules/patch-plan"
  
  environment = "test"
  patch_group_name = "test-1"
  
  # Maintenance window configuration
  enable_maintenance_window = true
  maintenance_window_schedule_mode = "immediate"
  maintenance_window_offset = "5m"
  
  # SSM association configuration
  enable_scan_task = true
  scan_association_schedule_mode = "immediate"
  scan_association_offset = "2m"
  
  # Required variables
  maintenance_window_automation_execution_role_arn = module.base_infra.automation_execution_role_arn
  
  tags = {
    Environment = "test"
    Purpose     = "patching"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name | `string` | n/a | yes |
| patch_group_name | Name of the patch group | `string` | n/a | yes |
| maintenance_window_automation_execution_role_arn | ARN of the automation execution role | `string` | n/a | yes |
| enable_maintenance_window | Whether to create maintenance windows | `bool` | `true` | no |
| enable_scan_task | Whether to create the scan task | `bool` | `true` | no |
| maintenance_window_schedule_mode | Schedule mode: 'immediate' or 'configured' | `string` | `"configured"` | no |
| scan_association_schedule_mode | Scan schedule mode: 'immediate' or 'configured' | `string` | `"configured"` | no |

## Outputs

| Name | Description |
|------|-------------|
| maintenance_window_id | ID of the maintenance window |
| maintenance_window_arn | ARN of the maintenance window |
| maintenance_window_target_id | ID of the maintenance window target |
| maintenance_window_task_id | ID of the maintenance window task |
| ssm_association_id | ID of the SSM association for patch scanning |
| ssm_association_arn | ARN of the SSM association for patch scanning |

## Resources Created

- `aws_ssm_maintenance_window` - Maintenance window for patch installation
- `aws_ssm_maintenance_window_target` - Target for maintenance window
- `aws_ssm_maintenance_window_task` - Task for maintenance window
- `aws_ssm_association` - SSM association for patch scanning 