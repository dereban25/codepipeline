import boto3
from env_vars import role_name

def get_assume_credentials(account_id):
    sts_client = boto3.client('sts')
    assumed_role = sts_client.assume_role(
        RoleArn=f'arn:aws:iam::{account_id}:role/{role_name}',
        RoleSessionName='AssumeRoleSessionName'
    )

    credentials = assumed_role['Credentials']
    
    return credentials