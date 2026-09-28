# AWS Cost Optimization & Automated Resource Cleanup

An AWS-based cost optimization system that automatically identifies and removes orphaned EBS snapshots using AWS Lambda and EventBridge. The infrastructure is managed with Terraform and deployed through GitHub Actions using AWS OIDC authentication.

## 🚀 Project Overview

Unused AWS resources can continue generating unnecessary costs even when they are no longer actively used.

This project automates the cleanup of orphaned EBS snapshots. When an EBS volume is deleted but its snapshot remains, the Lambda function identifies the snapshot as orphaned and removes it automatically.

The project also uses CloudWatch for monitoring and logging and SNS for email notifications when cleanup actions are performed.

## 🏗️ Architecture

```text
                         GitHub Repository
                                |
                                v
                       GitHub Actions CI/CD
                                |
                         OIDC Authentication
                                |
                                v
                         AWS IAM Role
                                |
                                v
                            Terraform
                                |
              +-----------------+-----------------+
              |                 |                 |
              v                 v                 v
         EventBridge         Lambda          CloudWatch
          Scheduler         Cleanup          Logs/Alarm
              |                 |                 |
              |                 v                 |
              |          EBS Snapshot Check       |
              |                 |                 |
              |        Orphaned Snapshot?         |
              |                 |                 |
              |              Delete               |
              |                 |                 |
              +--------------->+<----------------+
                                |
                                v
                              SNS
                                |
                                v
                         Email Notification
🔄 How It Works
Terraform provisions the required AWS infrastructure.
GitHub Actions deploys and manages the infrastructure automatically.
EventBridge triggers the Lambda function according to the configured schedule.
Lambda retrieves EBS snapshots owned by the AWS account.
Lambda checks whether the volume associated with each snapshot still exists.
If the associated volume no longer exists, the snapshot is considered orphaned.
Lambda deletes the orphaned snapshot.
Cleanup activity is recorded in CloudWatch Logs.
When snapshots are deleted, Lambda publishes a notification to SNS.
SNS sends an email notification to the confirmed subscription.
☁️ AWS Services Used
AWS Lambda – Executes the snapshot cleanup logic.
Amazon EC2 / EBS – Provides the volumes and snapshots being monitored.
Amazon EventBridge – Schedules automatic Lambda execution.
Amazon CloudWatch – Stores Lambda logs and monitors Lambda metrics.
Amazon SNS – Sends email notifications after cleanup actions.
AWS IAM – Provides least-privilege permissions to Lambda and GitHub Actions.
Amazon S3 – Stores the Terraform remote state.
AWS Cost Explorer / Budgets – Used for cloud cost monitoring.
Terraform – Provisions and manages the AWS infrastructure.
GitHub Actions – Automates Terraform validation, planning, and deployment.
GitHub OIDC – Allows GitHub Actions to authenticate with AWS without storing long-lived AWS access keys.
🛠️ Tech Stack
Cloud       : AWS
IaC         : Terraform
Language    : Python
Automation  : GitHub Actions
CI/CD       : GitHub Actions
Authentication : AWS OIDC
Monitoring  : CloudWatch
Scheduling  : EventBridge
Notification: SNS
Storage     : S3
📁 Project Structure
AWS-COST/
│
├── lambda/
│   └── lambda_function.py
│
├── terraform/
│   ├── backend.tf
│   ├── iam.tf
│   ├── lambda.tf
│   ├── sns.tf
│   ├── cloudwatch.tf
│   ├── eventbridge.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── lambda.zip
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
└── README.md
🔐 Security

The project uses GitHub OIDC for authentication instead of storing long-lived AWS access keys inside GitHub.

The Lambda execution role is configured with permissions required for:

Describing EBS snapshots
Describing EBS volumes
Deleting orphaned snapshots
Publishing notifications to SNS
Writing logs to CloudWatch

GitHub Actions assumes a dedicated IAM role through OIDC to execute Terraform operations.

📊 Monitoring

CloudWatch is used to monitor Lambda execution.

The project tracks:

Lambda execution logs
Cleanup results
Deleted snapshot information
Lambda metrics
Lambda throttling

A CloudWatch alarm is also configured for Lambda throttling and sends notifications through SNS.

📧 Notifications

SNS is integrated with the cleanup Lambda.

When orphaned snapshots are successfully deleted, Lambda publishes a cleanup report to SNS.

Example:

AWS Cost Optimization Cleanup Report

Deleted snapshots:
snap-xxxxxxxxxxxxxxxxx

Total deleted: 1

The confirmed SNS subscription then delivers the notification through email.

🧪 End-to-End Testing

The complete workflow was tested using a real AWS resource lifecycle:

EC2 Instance
      ↓
EBS Volume
      ↓
EBS Snapshot
      ↓
EC2 Instance Terminated
      ↓
EBS Volume Deleted
      ↓
Snapshot Remained
      ↓
Lambda Detected Orphaned Snapshot
      ↓
Snapshot Deleted
      ↓
CloudWatch Logs Updated
      ↓
SNS Notification Sent
      ↓
Email Received

The end-to-end cleanup workflow was successfully verified.

🔄 CI/CD Workflow

GitHub Actions automates Terraform operations whenever changes are pushed to the repository.

Git Push
   ↓
GitHub Actions
   ↓
Terraform Format
   ↓
Terraform Validate
   ↓
Terraform Init
   ↓
Terraform Plan
   ↓
Terraform Apply
   ↓
AWS Infrastructure Updated

Terraform state is stored remotely in Amazon S3, allowing the local and GitHub Actions workflows to use the same state.

🎯 Key Features
Automated orphaned EBS snapshot cleanup
Scheduled Lambda execution
Infrastructure as Code using Terraform
Remote Terraform state using S3
GitHub Actions CI/CD
GitHub OIDC authentication
CloudWatch logging and monitoring
Lambda throttling alarm
SNS email notifications
IAM-based access control
End-to-end AWS resource cleanup validation
💡 Why This Project?

The goal of this project is to demonstrate how AWS, Terraform, Python, and DevOps automation can be combined to reduce unnecessary cloud resource usage while maintaining monitoring, security, and automated deployment.

👨‍💻 Author