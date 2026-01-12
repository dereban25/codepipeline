from datetime import datetime, timedelta, timezone

from env_vars import tag_key, tag_value, days

def get_snapshot(ec2_client):
    # Get snapshots with specific tag
    snapshots = ec2_client.describe_snapshots(Filters=[
        {'Name': f'tag:{tag_key}', 'Values': [tag_value]}
    ])['Snapshots']
    
    # Filter snapshots older than specified days
    cutoff_date = datetime.now(timezone.utc) - timedelta(days=days)
    snapshots_to_delete = [snap['SnapshotId'] for snap in snapshots if snap['StartTime'] < cutoff_date]

    return snapshots_to_delete  # Ensure the function always returns a list
