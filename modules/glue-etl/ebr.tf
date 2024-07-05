resource "aws_cloudwatch_event_rule" "ebr" {
  name = local.ebr_event_source_created
  description = "capture PutObject events on S3 source bucket"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created"],
    "detail": {
        "bucket": {
        "name": ["${var.source_bucket}"]
        }
    }
})
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.ebr.name
  arn = aws_lambda_function.router.arn
}