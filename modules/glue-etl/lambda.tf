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
        "glue:StartJobRun"
    ]
    resources = [ "arn:aws:glue:eu-west-2:*:job/${var.job_name}" ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "nihrd-iam-rddi-${var.env}-lambda-${var.job_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  inline_policy {
        name = "nihrd-iam-rddi-${var.env}-policy-${var.job_name}"
        policy = data.aws_iam_policy_document.lambda_permissions.json
  }
}

resource "aws_lambda_function" "router" {
  function_name = local.func_name
  role = aws_iam_role.iam_for_lambda.arn
  image_uri = local.image_uri
  package_type = "Image"
  environment {
    variables = {
      "TARGET_BUCKET": var.target_bucket
      "JOB_NAME": var.job_name
    }
  }
}