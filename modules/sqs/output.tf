output "bb_sqs_url" {
  description = "The URL of the bb SQS queue"
  value       = aws_sqs_queue.bb_sqs.url
}

output "bb_sqs_arn" {
  description = "The ARN of the bb SQS queue"
  value       = aws_sqs_queue.bb_sqs.arn
}