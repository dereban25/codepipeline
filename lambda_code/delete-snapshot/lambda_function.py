import boto3
from datetime import datetime, timedelta, timezone

from env_vars import role_name, regions_to_process, sns_topic_arn
from ec2_client import get_ec2_client
from delete_snapshot import delete_snapshot
from fetch_target_org_accounts import get_target_accounts_ids
from get_assume_credentials import get_assume_credentials
from get_snapshot import get_snapshot
from sns_report import sns_report

def lambda_handler(event, context):
    target_account_ids = get_target_accounts_ids()
    response_body = ""
    
    for account_id in target_account_ids:
        try:
            credentials = get_assume_credentials(account_id)
            snapshot_deleted_map = {} 

            # Process snapshots for each specified region
            for region in regions_to_process:
                try:
                    ec2 = get_ec2_client(credentials, region)
                    snapshots_to_delete = get_snapshot(ec2)
                    snapshot_deleted_map = delete_snapshot(ec2, account_id, region, snapshots_to_delete, snapshot_deleted_map)
                except Exception as e:
                    print(f"Error processing snapshots for account {account_id} in region {region}: {e}")
            
            sns_message = sns_report(snapshot_deleted_map)
            response_body += f'Snapshots deleted successfully for account {account_id}.\n\n{sns_message}\n\n'
        
        except Exception as e:
            print(f"Error processing account {account_id}: {e}")
    
    return {
        'statusCode': 200,
        'body': response_body
    }
