import boto3


def lambda_handler(event, context):

    ec2 = boto3.client("ec2")

    response = ec2.describe_snapshots(
        OwnerIds=["self"]
    )

    snapshots = response.get("Snapshots", [])

    print(f"Found {len(snapshots)} snapshots.")

    for snapshot in snapshots:
        snapshot_id = snapshot["SnapshotId"]
        start_time = snapshot["StartTime"]

        print(
            f"Snapshot ID: {snapshot_id}, "
            f"Created: {start_time}"
        )

    return {
        "statusCode": 200,
        "body": f"Found {len(snapshots)} snapshots."
    }