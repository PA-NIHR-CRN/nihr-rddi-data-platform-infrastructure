locals {
  bucket_permissions = [
    "arn:aws:s3:::${var.source_bucket}",
    "arn:aws:s3:::${var.target_bucket}"
  ]
}

data "aws_iam_policy_document" "job_assume_role" {
  statement {
    sid = "GlueAsumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
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

resource "aws_iam_role" "glue_role" {
  name = "nihrd-role-rddi-${var.env}-glue-${var.job_name}"
  assume_role_policy = data.aws_iam_policy_document.job_assume_role.json
  inline_policy {
    name = "nihrd-policy-rddi-${var.env}-glue-${var.job_name}"
    policy = data.aws_iam_policy_document.job_permissions.json
  }
}

resource "aws_glue_job" "job" {
  name = var.job_name
  role_arn = aws_iam_role.glue_role.arn
  command {
    script_location = local.script_endpoint
  }
}