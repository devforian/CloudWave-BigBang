variable "infra_env" {}
variable "function_name" {}
variable "handler" {}
variable "runtime" {}
variable "package_path" {}
variable "sqs_arn" {} #sqs도 같이 넣어줘야 하지 않을까?
variable "subnet_ids" {}
#variable "security_group_ids" {}
variable "iam_policy_name" {}
variable "vpc_id" {}
# variable "source_code_path" {}