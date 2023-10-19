resource "aws_sqs_queue" "bb_sqs" {
  name = "bb-${var.infra_env}-${var.sqs_name}-sqs.fifo"
  fifo_queue = true
}