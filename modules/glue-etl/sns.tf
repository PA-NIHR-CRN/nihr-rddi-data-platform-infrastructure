resource "aws_sns_topic" "failure-topic" {
    name = "nihrd-sns-${var.env}-${var.system}-${var.stage}-failure" 
}