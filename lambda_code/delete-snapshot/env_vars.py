# Get environment variables
import os

exception_account_ids = os.getenv('EXCEPTION_ACCOUNT_IDS', '').split(',')
except_master_account = os.getenv('EXCEPT_MASTER_ACCOUNT', 'false').lower() == 'true'
role_name = os.getenv('ROLE_NAME', 'AWS-SystemsManager-AutomationExecutionRole')
days = int(os.getenv('DAYS', '10'))
tag_key = os.getenv('TAG_KEY', 'Patching')
tag_value = os.getenv('TAG_VALUE', 'DeleteAllow')
sns_topic_arn = os.getenv('SNS_TOPIC_ARN', '')
regions_to_process = os.getenv('REGIONS_TO_PROCESS', '').split(',')
