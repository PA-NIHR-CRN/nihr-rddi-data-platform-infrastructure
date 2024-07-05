locals {
  bucket_permissions = [
    "arn:aws:s3:::${var.source_bucket}",
    "arn:aws:s3:::${var.target_bucket}"
  ]
}

data "aws_iam_policy_document" "job_permissions" {
    statement {
      sid = "1"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      resources = local.bucket_permissions
    }
}

resource "aws_glue_job" "job" {
  name = var.job_name
  role_arn = data.aws_iam_policy_document.job_permissions.arn
  command {
    script_location = local.script_endpoint
  }
}