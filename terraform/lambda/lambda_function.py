import boto3
import os

ec2 = boto3.client("ec2")
sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")


def lambda_handler(event, context):

    snapshots = ec2.describe_snapshots(
        OwnerIds=["self"]
    )["Snapshots"]

    deleted_snapshots = []
    for snapshot in snapshots:
        snapshot_id = snapshot["SnapshotId"]
        volume_id = snapshot.get("VolumeId")
        if not volume_id:
            continue
        try:
            ec2.describe_volumes(
                VolumeIds=[volume_id]
            )

        except ec2.exceptions.ClientError as e:

            if "InvalidVolume.NotFound" in str(e):

                print(f"Deleting orphaned snapshot: {snapshot_id}")

                ec2.delete_snapshot(
                    SnapshotId=snapshot_id
                )

                deleted_snapshots.append(snapshot_id)

    message = (
        "AWS Cost Optimization Cleanup Report\n\n"
        f"Deleted snapshots: {deleted_snapshots}\n"
        f"Total deleted: {len(deleted_snapshots)}"
    )

    print(message)

    if SNS_TOPIC_ARN and deleted_snapshots:
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="AWS Cost Optimization Cleanup Alert",
            Message=message
        )

    return {
        "statusCode": 200,
        "deleted_snapshots": deleted_snapshots,
        "message": "Orphaned snapshot cleanup completed."
    }