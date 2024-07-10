resource "aws_mskconnect_custom_plugin" "plugin" {
  name         = var.custom_plugin_name
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = var.s3_connector_bucket_arn
      file_key   = "confluentinc-kafka-connect-s3-10.5.12.zip"
    }
  }
  description = "A custom plugin to transfer messages from message bus to S3 bucket."
}