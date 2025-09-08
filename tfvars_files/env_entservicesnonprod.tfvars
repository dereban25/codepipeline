environment      = "test"
region           = "us-west-2"
patch_prefix_name = "patching-ec2"
sns_email_address = "maksym.derbenov@empower.com"
s3_log_retention_days = 365
tags = {
  Owner       = "DevOps"
  Project     = "Patching"
  Team        = "DevOps"
}

####### ISSUES #######
# Review the server's Python version
# For Red Hat Enterprise Linux (RHEL), Debian Server, Raspberry Pi, or Ubuntu Server instances, make sure that you installed a supported version of Python 3. If you didn't install a supported version, then you receive the following error message:
# "An unsupported package manager and python version combination was found. Dnf requires Python 2 or Python 3 to be installed."
# To resolve this issue, install a version of Python 3 (3.0 - 3.9) on the required server.
# Review your OS
# If your operating system (OS) isn't supported, then you receive the following error message:
# "An error occurred (UnsupportedOperatingSystem) when calling the GetDeployablePatchSnapshotForInstance operation: patch_common.exceptions. PatchManagerError: ('Unsupported Operating System', 146)"
# To resolve this issue, use a supported OS for Patch Manager.
####### RESOLUTION #######
#  yum install python3


# =============================================================================
# MAINTENANCE WINDOW SCHEDULE AND SCAN CONFIGURATION
# =============================================================================

patch_plans = {
  # Global Patch Plan Configuration
  global = {
    enabled = true
    plan_name = "global"
    enable_scan_task = true
    enable_maintenance_window = true
    scan_association_schedule = "cron(0 2 ? * WED *)"
    scan_association_schedule_mode = "immediate"  # "immediate" or "configured"
    scan_association_offset = "1m"  # Used if scan_association_schedule_mode = "immediate"
    maintenance_window_schedule_mode = "immediate"  # "immediate" or "configured"
    maintenance_window_offset = "12m"  # Used if maintenance_window_schedule_mode = "immediate"
    target_instance = {
      tag_key = "ssmpatchgroup"
      tag_values = ["main", "Linux"]
    }
    maintenance_windows = {
      config = {
        schedule = "cron(0 2 ? * WED *)"  # Every Wednesday at 2 AM
        duration = 4
        cutoff = 1
        reboot_option = "RebootIfNeeded"
        priority = 1
        max_concurrency = "30"  # Can be number (e.g., '5') or percentage (e.g., '50%')
        max_errors = "0"         # Can be number (e.g., '5') or percentage (e.g., '50%')
        tags = {
          Schedule = "Weekly-Install"
          Type = "Universal"
        }
      }
    }
    tags = {
      Patch-plan = "global"
    }
  }
  
  # Development Patch Plan Configuration
  dev = {
    enabled = false
    plan_name = "dev"
    enable_scan_task = false
    enable_maintenance_window = true
    scan_association_schedule = "cron(0 2 ? * WED *)"
    scan_association_schedule_mode = "immediate"  # "immediate" or "configured"
    scan_association_offset = "3m"  # Used if scan_association_schedule_mode = "immediate"
    maintenance_window_schedule_mode = "immediate"  # "immediate" or "configured"
    maintenance_window_offset = "5m"  # Used if maintenance_window_schedule_mode = "immediate"
    target_instance = {
      tag_key = "ssspatchgroup"
      tag_values = ["dev"]
    }
    maintenance_windows = {
      config = {
        schedule = "cron(0 2 ? * WED *)"  # Every Wednesday at 2 AM
        duration = 4
        cutoff = 1
        reboot_option = "RebootIfNeeded"
        priority = 1
        max_concurrency = "5"  # Can be number (e.g., '5') or percentage (e.g., '50%')
        max_errors = "0"         # Can be number (e.g., '5') or percentage (e.g., '50%')
        tags = {
          Schedule = "Weekly-Install"
          Type = "Development"
        }
      }
    }
    tags = {
      Patch-plan = "dev"
    }
  }
}

# =============================================================================
# PATCH CONFIGURATION BASELINE AND PATCH GROUP CONFIGURATION
# =============================================================================

patch_configs = {
  # Ubuntu Configuration
  ubuntu = {
    enabled = true
    operating_system = "UBUNTU"
    patch_group_suffix = "ubuntu"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["Ubuntu14.04", "Ubuntu16.04", "Ubuntu18.04", "Ubuntu20.04", "Ubuntu20.10", "Ubuntu22.04", "Ubuntu23", "Ubuntu23.04", "Ubuntu23.10", "Ubuntu24", "Ubuntu24.04", "Ubuntu24.10", "Ubuntu25", "Ubuntu25.04"]
          }
        ]
      }
    ]
    tags = {
      OS = "Ubuntu"
      Priority = "High"
    }
  }
  
  # Windows Configuratio
  windows = {
    enabled = true
    operating_system = "WINDOWS"
    patch_group_suffix = "windows"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = false
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["Windows7", "Windows8", "Windows8.1", "Windows8Embedded", "Windows10", "Windows10LTSB", "WindowsServer2008", "WindowsServer2012", "WindowsServer2008R2", "WindowsServer2012R2", "WindowsServer2016", "WindowsServer2019", "WindowsServer2022", "WindowsServer2025", "MicrosoftDefenderAntivirus"]
          }
        ]
      }
    ]
    tags = {
      OS = "Windows"
      Priority = "High"
    }
  }
  
  # RedHat 7 Configuration
  redhat7 = {
    enabled = true
    operating_system = "REDHAT_ENTERPRISE_LINUX"
    patch_group_suffix = "redhat7"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["RedhatEnterpriseLinux7", "RedhatEnterpriseLinux7.0", "RedhatEnterpriseLinux7.1", "RedhatEnterpriseLinux7.2", "RedhatEnterpriseLinux7.3", "RedhatEnterpriseLinux7.4", "RedhatEnterpriseLinux7.5", "RedhatEnterpriseLinux7.6", "RedhatEnterpriseLinux7.7", "RedhatEnterpriseLinux7.8", "RedhatEnterpriseLinux7.9"]
          }
        ]
      }
    ]
    tags = {
      OS = "RedHat7"
      Priority = "High"
    }
  }
  
  # RedHat 8 Configuration
  redhat8 = {
    enabled = true
    operating_system = "REDHAT_ENTERPRISE_LINUX"
    patch_group_suffix = "redhat8"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["RedhatEnterpriseLinux8.0", "RedhatEnterpriseLinux8.1", "RedhatEnterpriseLinux8.2", "RedhatEnterpriseLinux8.3", "RedhatEnterpriseLinux8.4", "RedhatEnterpriseLinux8.5", "RedhatEnterpriseLinux8.6", "RedhatEnterpriseLinux8.7", "RedhatEnterpriseLinux8.8", "RedhatEnterpriseLinux8.9", "RedhatEnterpriseLinux8.10"]
          }
        ]
      }
    ]
    tags = {
      OS = "RedHat8"
      Priority = "High"
    }
  }
  redhat9 = {
    enabled = true
    operating_system = "REDHAT_ENTERPRISE_LINUX"
    patch_group_suffix = "redhat9"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
        {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
            {
            key = "PRODUCT"
            values = ["RedhatEnterpriseLinux9", "RedhatEnterpriseLinux9.0", "RedhatEnterpriseLinux9.1", "RedhatEnterpriseLinux9.2", "RedhatEnterpriseLinux9.3", "RedhatEnterpriseLinux9.4", "RedhatEnterpriseLinux9.5", "RedhatEnterpriseLinux9.6"]
            }
        ]
        }
    ]
    tags = {
        OS = "RedHat9"
        Priority = "High"
    }
    }
  # Oracle Linux 9 Configuration
  oraclelinux9 = {
    enabled = true
    operating_system = "ORACLE_LINUX"
    patch_group_suffix = "oraclelinux9"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["OracleLinux9", "OracleLinux9.0", "OracleLinux9.1", "OracleLinux9.2", "OracleLinux9.3", "OracleLinux9.4", "OracleLinux9.5"]
          }
        ]
      }
    ]
    tags = {
      OS = "OracleLinux9"
      Priority = "High"
    }
  }
  amazon = {
    enabled = true
    operating_system = "AMAZON_LINUX_2023"
    patch_group_suffix = "amazon"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["AmazonLinux2023"]
          }
        ]
      }
    ]
    tags = {
      OS = "Amazon"
      Priority = "High"
    }
  }
  amazon2 = {
    enabled = true
    operating_system = "AMAZON_LINUX_2"
    patch_group_suffix = "amazon2"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["AmazonLinux2", "AmazonLinux2.0"]
          }
        ]
      }
    ]
    tags = {
      OS = "Amazon2"
      Priority = "High"
    }
  }
  amazon_linux = {
    enabled = true
    operating_system = "AMAZON_LINUX"
    patch_group_suffix = "amazon_linux"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["AmazonLinux2012.03", "AmazonLinux2012.09", "AmazonLinux2013.03", "AmazonLinux2013.09", "AmazonLinux2014.03", "AmazonLinux2014.09", "AmazonLinux2015.03", "AmazonLinux2015.09", "AmazonLinux2016.03", "AmazonLinux2016.09", "AmazonLinux2017.03", "AmazonLinux2017.09", "AmazonLinux2018.03"]
          }
        ]
      }
    ]
    tags = {
      OS = "Amazon"
      Priority = "High"
    }
  }
  oraclelinux7 = {
    enabled = true
    operating_system = "ORACLE_LINUX"
    patch_group_suffix = "oraclelinux7"
    approved_patches_compliance_level = "UNSPECIFIED"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level = "UNSPECIFIED"
        enable_non_security = true
        patch_filters = [
          {
            key = "PRODUCT"
            values = ["OracleLinux7.5", "OracleLinux7.6", "OracleLinux7.7", "OracleLinux7.8","OracleLinux7.9"]
          }
        ]
      }
    ]
    tags = {
      OS = "OracleLinux7"
      Priority = "High"
    }
  }
}
