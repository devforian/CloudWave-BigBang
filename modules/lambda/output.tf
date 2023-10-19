output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.bb_lambda.arn
}

output "lambda_function_invoke_arn" {
  value       = aws_lambda_function.bb_lambda.invoke_arn
}


output "lambda_iam_policy_arn" {
  description = "The ARN of the IAM policy for the Lambda function"
  value       = aws_iam_policy.bb_lambda_sqs_policy.arn
}

output "lambda_iam_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  value       = aws_iam_role.bb_role_lambda_sqs.arn
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.bb_labmda_sg.id
}