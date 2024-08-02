import boto3
from env_vars import sns_topic_arn

def sns_report(snapshot_deleted_map):
    # Format SNS message
    sns_message = ""
    for account_id, region_snapshot_map in snapshot_deleted_map.items():
        sns_message += f"📄 Account ID: {account_id}\n"
        for region, snapshots in region_snapshot_map.items():
            sns_message += f"Region: {region}\n"
            sns_message += "\n".join(snapshots)
            sns_message += "\n\n"

    # Publish SNS notification
    if sns_topic_arn and sns_message:
        sns_client = boto3.client('sns')
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=sns_message,
            Subject='Snapshot Deletion Report'
        )
        
    return sns_message