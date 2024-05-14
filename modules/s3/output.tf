output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The ARN of the created S3 bucket"
}