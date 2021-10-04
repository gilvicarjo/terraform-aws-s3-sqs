# AWS S3 service interacting with SQS notifications  

## The Environment

In that environment are being created a S3 Bucket and a SQS Queue
They are connected to each other because the queue should be notified when a upload occurs to S3

The S3 bucket is referenced in Terraform as 'bucket'and named as 'bucket_files_s3-[sequential-id-variable]'. There is a private ACL

The SQS queue is referenced as 'queue' and named as 's3_notification_queue'

The statement works only for this specific bucket.

The bucket notification (Terraform object named as 'bucket_notif') send a message to 's3_notification_queue'

## To be improved

- Add more parameters in the SQS Queue as: Delay, Max Message Size, Message retention
- Add variables and datasources for provider setup