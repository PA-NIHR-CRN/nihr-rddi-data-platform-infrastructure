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
tags_all = merge(local.default_tags,{
  "Name": local.ebr_event_source_created,
})
}

resource "aws_cloudwatch_event_rule" "OnFailure" {
  name = local.ebr_event_failure
  description = "Sends a msg to SNS topic on job failure"
  event_pattern = jsonencode({
    "source": ["aws.glue"],
    "detail-type": ["Glue Job State Change"],
    "detail": {
      "state": ["FAILED"]
    }
})
tags_all = merge(local.default_tags,{
  "Name": local.ebr_event_failure
})
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  depends_on = [ aws_lambda_function.router ]
  rule = aws_cloudwatch_event_rule.ebr.name
  arn = aws_lambda_function.router.arn
}

resource "aws_cloudwatch_event_target" "sns_target" {
  depends_on = [ aws_sns_topic.failure-topic ]
  rule = aws_cloudwatch_event_rule.OnFailure.name
  arn = aws_sns_topic.failure-topic.arn
}