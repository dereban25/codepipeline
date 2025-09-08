# Patch Configuration Module

This Terraform module creates AWS Systems Manager patch baselines, patch groups, and maintenance windows for automated patching operations.

## Features

- **Patch Baseline**: Configurable patch baseline with approval rules and patch filters
- **Patch Group**: Associates instances with the patch baseline
- **Maintenance Window**: Automated patching execution with flexible scheduling options
- **Flexible Scheduling**: Support for both immediate execution and cron-based scheduling

## Usage

```hcl
module "ubuntu_patching" {
  source = "./modules/patch-config"
  
  environment = "prod"
  patch_group_name = "ubuntu-servers"
  operating_system = "UBUNTU"
  
  # Schedule configuration
  maintenance_window_schedule_mode = "immediate"  # or "configured"
  maintenance_window_offset = "10m"               # for immediate mode
  
  maintenance_windows = {
    config = {
      schedule = "cron(0 2 ? * WED *)"  # Primary schedule source (for configured mode)
      duration = 2
      cutoff = 1
      priority = 1
      reboot_option = "RebootIfNeeded"
      tags = {
        Environment = "prod"
        OS = "ubuntu"
      }
    }
  }
  
  tags = {
    Environment = "prod"
    Project = "patching"
  }
}
```

## Schedule Configuration

### Schedule Source Priority
1. **Immediate Mode**: Generated cron expression for one-time execution
2. **Configured Mode**: `maintenance_windows["config"].schedule` from the map
3. **Fallback**: `maintenance_window_schedule` variable (if schedule not specified in map)

### Immediate Mode
Set `maintenance_window_schedule_mode = "immediate"` to start the maintenance window after a specified offset from when Terraform is applied.

```hcl
maintenance_window_schedule_mode = "immediate"
maintenance_window_offset = "5m"  # 5 minutes after apply
```

**Behavior**: 
- Generates a cron expression for the calculated start time (e.g., `cron(30 15 ? 12 * 2024)`)
- Maintenance window runs once at the calculated start time
- Uses the generated cron as the schedule

### Configured Mode
Set `maintenance_window_schedule_mode = "configured"` to use a cron expression for recurring maintenance windows.

```hcl
maintenance_window_schedule_mode = "configured"
# Schedule comes from maintenance_windows["config"].schedule
```

**Behavior**:
- Uses the schedule from `maintenance_windows["config"].schedule`
- Maintenance window runs on the recurring schedule

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| patch_group_name | Name for the patch group | `string` | n/a | yes |
| operating_system | Operating system for the patch baseline | `string` | n/a | yes |
| maintenance_window_schedule_mode | How to schedule the maintenance window: 'immediate' or 'configured' | `string` | `"configured"` | no |
| maintenance_window_offset | Offset from now for immediate maintenance window start | `string` | `"5m"` | no |
| maintenance_window_schedule | Cron expression for maintenance window schedule (fallback) | `string` | `"cron(0 2 ? * WED *)"` | no |
| maintenance_windows | Map of maintenance window configurations | `map(object)` | n/a | yes |
| tags | Common tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| patch_baseline_id | ID of the created patch baseline |
| patch_baseline_arn | ARN of the created patch baseline |
| patch_group_name | Name of the created patch group |
| maintenance_window_id | ID of the created maintenance window |
| maintenance_window_target_id | ID of the maintenance window target |
| maintenance_window_task_id | ID of the maintenance window task |
| maintenance_window_schedule | The computed schedule for the maintenance window |
| maintenance_window_schedule_mode | The schedule mode used for the maintenance window |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Module Structure

```
terraform/modules/patch-config/
├── main.tf                    # Data sources
├── patch-baseline.tf          # Patch baseline resources
├── patch-group.tf             # Patch group resources
├── maintenance-window.tf      # Maintenance window resources
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
└── README.md                  # This documentation
```

## Resources Created

### Patch Baseline (`patch-baseline.tf`)
- **SSM Patch Baseline**: Defines which patches are approved and rejected
- **Approval Rules**: Configurable rules for automatic patch approval
- **Operating System Support**: Configurable for different OS types
- **Compliance Level**: Set to HIGH for security compliance

### Patch Group (`patch-group.tf`)
- **SSM Patch Group**: Associates instances with patch baselines
- **Automatic Association**: Links to the created patch baseline

### Maintenance Window (`maintenance-window.tf`)
- **SSM Maintenance Window**: Scheduled time windows for patching
- **Maintenance Window Target**: Targets instances by patch group tag
- **Scan Task**: Uses AWS-RunPatchBaseline to scan for available patches
- **Install Task**: Uses custom SSM document to install patches with rollback capability
- **Uses base-infra role**: Leverages the automation execution role from base-infra module

## Features

- **Integrated Configuration**: All patching components in one module
- **Flexible Scheduling**: Configurable maintenance windows with cron expressions
- **Security Compliance**: HIGH compliance level for patch baselines
- **Dual-Task Patching**: Separate scan and install operations for safety
- **Automated Patching**: Uses SSM automation documents for patching
- **Instance Targeting**: Targets instances by patch group tags
- **Shared IAM Role**: Uses the automation execution role from base-infra module

## Dependencies

- AWS Provider configured
- Proper AWS credentials and permissions
- SSM document for patching automation
- Automation execution role from base-infra module
- Instances tagged with appropriate patch group

## Notes

- This module is designed to be deployed per patch group
- Instances must be tagged with `Patch Group` = `patch_group_name`
- Maintenance windows run automatically based on the schedule
- Patch baselines control which patches are applied
- All resources are properly tagged for cost tracking and organization
- Resources are organized in separate files for better maintainability
- Maintenance window uses the automation execution role from base-infra module for consistency
- Two-step patching process: scan first, then install for safety 