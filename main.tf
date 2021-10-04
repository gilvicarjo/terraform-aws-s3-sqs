provider "aws" {
    region = var.region
    profile = "aws_keys" 
    #Must store AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY 
    #in a profile called 'aws_keys' when setting up "$ aws configure"
    #Or you can choose the profile name there and change here.
}

resource "aws_sqs_queue" "queue" {
    name = "s3_notifications_queue"

    policy = <<POLICY
{
    "Version": "2021-09-26",
    "Statement": [
      {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "sqs:SendMessage",
          "Resource": "arn:aws:sqs:*:*:s3_notifications_queue",
          "Condition: {
            "ArnEquals": {"aws:SourceArn": "${aws_s3_bucket.bucket.arn}" }
           }
        }
    ]
}
POLICY
}

resource "random_string" "id" {
  length = "3"
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
    bucket = "bucket_files_s3-${random_string.id.result}"
}

resource "aws_s3_bucket_notificastion" "bucket_notification" {
    count = "${var.event ? 1 : 0 }"
    bucket = "${aws_s3_bucket.bucket.id}"

    queue {
        queue_arn = "${aws_sqs_queue.queue.arn}"
        events    = ["s3:ObjectCreated:Put"]
    }
}