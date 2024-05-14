output "bucket_arn" {
  value       = module.aws_s3_bucket.arn
  description = "The ARN of the created S3 bucket"
}