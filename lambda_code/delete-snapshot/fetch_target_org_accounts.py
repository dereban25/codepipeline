import boto3
from env_vars import exception_account_ids, except_master_account

def get_target_accounts_ids():

    # Get the master account ID
    org_client = boto3.client('organizations')
    master_account_id = org_client.describe_organization()['Organization']['MasterAccountId']

    if except_master_account:
        # Add the master account to the exception list
        exception_account_ids.append(master_account_id)

    # List all accounts in the organization with pagination
    target_account_ids = []
    paginator = org_client.get_paginator('list_accounts')
    for page in paginator.paginate():
        for account in page['Accounts']:
            if account['Status'] == 'ACTIVE' and account['Id'] not in exception_account_ids:
                target_account_ids.append(account['Id'])

    if not target_account_ids:
        return {
            'statusCode': 200,
            'body': 'No active target accounts found.'
        }
    
    return target_account_ids