import boto3
import os

client = boto3.client('ssm')

def lambda_handler(event, context):
    TargetAccounts = os.environ['TargetAccounts']
    TargetRegionIds = os.environ['TargetRegionIds']
    MasterAccountID = os.environ['MasterAccountID']
    ResourceGroupName = os.environ['ResourceGroupName']
    TargetLocationMaxConcurrency = os.environ['TargetLocationMaxConcurrency']
    TargetLocationMaxErrors = os.environ['TargetLocationMaxErrors']
    DocumentName = os.environ['DocumentName']
    ReportS3Bucket = os.environ['ReportS3Bucket']

    TargetAccountsArray = TargetAccounts.split(",")
    TargetRegionIdsArray = TargetRegionIds.split(",")

    # Start automation execution
    response = client.start_automation_execution(
        DocumentName=DocumentName,
        TargetParameterName='InstanceId',
        Parameters={
            'AutomationAssumeRole': [f'arn:aws:iam::{MasterAccountID}:role/AWS-SystemsManager-AutomationAdministrationRole'],
            #'ReportS3Bucket': [ReportS3Bucket]
        },
        Targets=[
            {
                'Key': 'ResourceGroup',
                'Values': [ResourceGroupName]
            }
        ],
        TargetLocations=[
            {
                'Accounts': TargetAccountsArray,
                'Regions': TargetRegionIdsArray,
                'TargetLocationMaxConcurrency': TargetLocationMaxConcurrency,
                'TargetLocationMaxErrors': TargetLocationMaxErrors,
                'ExecutionRoleName': 'AWS-SystemsManager-AutomationExecutionRole'
            }
        ]
    )

    print(response)
