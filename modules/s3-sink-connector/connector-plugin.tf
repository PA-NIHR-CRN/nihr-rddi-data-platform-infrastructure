resource "aws_s3_object" "source" {
  bucket = var.s3_connector_bucket_id
  key    = "confluentinc-kafka-connect-s3-10.5.12.zip"
  source = "confluentinc-kafka-connect-s3-10.5.12.zip"
}

resource "aws_mskconnect_custom_plugin" "plugin" {
  name         = var.custom_plugin_name
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = var.s3_connector_bucket_arn
      file_key   = aws_s3_object.source.key
    }
  }
  description = "A custom plugin to transfer messages from message bus to S3 bucket."
}