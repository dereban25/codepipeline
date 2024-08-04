def delete_snapshot(ec2_client, account_id, region, snapshots_to_delete, snapshot_deleted_map):
    for snapshot_id in snapshots_to_delete:
        try:
            ec2_client.delete_snapshot(SnapshotId=snapshot_id)
            snapshot_deleted_map.setdefault(account_id, {}).setdefault(region, []).append(snapshot_id)
        except Exception as e:
            print(f"Error deleting snapshot {snapshot_id} in account {account_id}, region {region}: {e}")
    
    return snapshot_deleted_map
