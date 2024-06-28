locals {
  bucket_permissions = [
    "arn:aws:s3:::${var.source_bucket}",
    "arn:aws:s3:::${var.target_bucket}"
  ]
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_permissions" {
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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  inline_policy {
    name = "nihrd-policy-rddi-${var.env}-${var.name}"
    policy = data.aws_iam_policy_document.lambda_permissions.json
  }
}

resource "aws_lambda_function" "lambda" {
    function_name = "nihrd-lambda-rddi-${var.env}-${var.name}"
    role = aws_iam_role.iam_for_lambda.arn
    image_uri = var.image
    package_type = "Image"
    environment {
      variables = {
        "TARGET_BUCKET" = var.target_bucket
      }
    }

    tags = {
      Name = aws_iam_role.iam_for_lambda.name
      Environment = var.env
      System = var.system
    }

}

/*
// Example Import
module "raw_convert_lambda" {
  source = "./modules/dp-lambda-raw"
  name = var.names["${var.env}"]["lambda_name_raw_convert"]
  target_bucket = var.names["${var.env}"]["bucket_name_bronze"]
  source_bucket = var.names["${var.env}"]["bucket_name"]
  env = var.env
  system = var.names["system"]
}
*/

