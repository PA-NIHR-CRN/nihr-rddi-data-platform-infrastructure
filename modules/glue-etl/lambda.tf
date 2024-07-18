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
    resources = [ "arn:aws:glue:eu-west-2:*:job/${local.glue_job_name}" ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "nihrd-iam-rddi-${var.env}-${var.system}-${var.stage}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  inline_policy {
        name = "nihrd-iam-rddi-${var.env}-${var.system}-${var.stage}-lambda-policy"
        policy = data.aws_iam_policy_document.lambda_permissions.json
  }
  tags_all = merge(local.default_tags,{
    "Name": local.func_name,
  })
}

resource "aws_lambda_function" "router" {
  function_name = local.func_name
  role = aws_iam_role.iam_for_lambda.arn
  image_uri = local.image_uri
  package_type = "Image"
  environment {
    variables = {
      "TARGET_BUCKET": var.target_bucket
      "JOB_NAME": local.glue_job_name
      "EXTRA_PY_DEPS": join(",",local.install_deps)
    }
  }
  tags = merge(local.default_tags,{
    "Name": local.func_name,
  })
}