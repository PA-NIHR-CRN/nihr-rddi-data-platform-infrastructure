locals {
  script_bucket_name = "nihrd-s3-${var.env}-rddi-glue-scripts"
  script_endpoint = "s3://${local.script_bucket_name}/${aws_s3_object.script.key}"
  image_uri = ""
  func_name = "nihrd-lambda-rddi-${var.env}-${var.job_name}"
  ebr_event_source_created = "nihrd-ebr-rddi-${var.env}-${var.job_name}-created"
}