resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic_name
  tags = merge(
    local.common_tags,
    {
      Name = var.sns_topic_name
    }
  )
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function.arn
}