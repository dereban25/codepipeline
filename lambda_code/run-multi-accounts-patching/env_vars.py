import os

automation_assume_role = os.environ['AUTOMATION_ASSUME_ROLE']
document_name = os.environ['DOCUMENT_NAME']
execution_role_name = os.environ['EXECUTION_ROLE_NAME']
report_S3_bucket = os.environ['REPORT_S3_BUCKET']
resource_group_name = os.environ['RESOURCE_GROUP_NAME']
target_location_max_concurrency = os.environ['TARGET_LOCATION_MAX_CONCURRENCY']
target_location_max_errors = os.environ['TARGET_LOCATION_MAX_ERRORS']
target_region_ids = os.environ['TARGET_REGION_IDS'].split(',')
sns_topic_arn = os.environ['SNS_TOPIC_ARN']
exception_account_ids = os.getenv('EXCEPTION_ACCOUNT_IDS', '').split(',')
except_master_account = os.getenv('EXCEPT_MASTER_ACCOUNT', 'false').lower() == 'true'
