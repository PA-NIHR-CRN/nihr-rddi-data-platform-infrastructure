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
  name = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.job_assume_role.json
  inline_policy {
    name = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-policy"
    policy = data.aws_iam_policy_document.job_permissions.json
  }
}

resource "aws_glue_job" "job" {
  name = local.glue_job_name
  role_arn = aws_iam_role.glue_role.arn
  command {
    script_location = local.script_endpoint
  }

  default_arguments = {
    "--stage": var.stage,
    "--enable-metrics": true
    "--spark-event-logs-path": "s3://aws-glue-assets-${var.accountId}-${var.region}/sparkHistoryLogs/"
    "--enable-job-insights": false
    "--enable-observability-metrics": true
    "--enable-glue-datacatalog": true
    "--enable-continuous-cloudwatch-log": true
    "--job-bookmark-option": "job-bookmark-disable"
    "--job-language": "python"
    "--TempDir": "s3://aws-glue-assets-${var.accountId}-${var.region}/temporary/"
  }

  tags = merge(local.default_tags,{
    "Name": local.glue_job_name
  })
}