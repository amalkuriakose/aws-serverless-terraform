resource "aws_sqs_queue" "sqs_queue" {
  name = var.sqs_queue_name
  tags = merge(
    local.common_tags,
    {
      Name = var.sqs_queue_name
    }
  )
}