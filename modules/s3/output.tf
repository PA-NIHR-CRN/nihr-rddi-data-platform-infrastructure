output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The ARN of the created S3 bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.bucket.id
  description = "The ID of the S3 bucket"
}