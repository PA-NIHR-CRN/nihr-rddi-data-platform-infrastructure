output "bucket_arn" {
  value       = module.s3_bucket.s3_bucket_arn
  description = "The ARN of the created S3 bucket"
}