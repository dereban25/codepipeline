import boto3
from datetime import datetime, timedelta, timezone
from env_vars import (
    document_name, automation_assume_role, report_S3_bucket, sns_topic_arn, 
    resource_group_name, target_region_ids, target_location_max_concurrency, 
    execution_role_name, target_location_max_errors
)
from fetch_target_org_accounts import get_target_accounts_ids

client = boto3.client('ssm')

def lambda_handler(event, context):
    accounts_info = get_target_accounts_ids()
    
    if 'statusCode' in accounts_info:
        return accounts_info
    
    master_account_id = accounts_info['master_account_id']
    target_account_ids = accounts_info['target_account_ids']
    
    # Start automation execution
    response = client.start_automation_execution(
        DocumentName=document_name,
        TargetParameterName='InstanceId',
        Parameters={
            'AutomationAssumeRole': [f'arn:aws:iam::{master_account_id}:role/{automation_assume_role}'],
            'ReportS3Bucket': [report_S3_bucket],
            'TopicArn': [sns_topic_arn]
        },
        Targets=[
            {
                'Key': 'ResourceGroup',
                'Values': [resource_group_name]
            }
        ],
        TargetLocations=[
            {
                'Accounts': target_account_ids,
                'Regions': target_region_ids,
                'TargetLocationMaxConcurrency': target_location_max_concurrency,
                'TargetLocationMaxErrors': target_location_max_errors, 
                'ExecutionRoleName': execution_role_name
            }
        ]
    )
    
    print(response)
    return {
        'statusCode': 200,
        'body': response
    }
