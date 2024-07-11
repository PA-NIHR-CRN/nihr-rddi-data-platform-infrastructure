data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "s3_connect_role" {
  name               = "${var.account}-iam-${var.env}-${var.system}-s3-sink-connector-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "kafkaconnect.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = {
    Name        = "${var.account}-iam-${var.env}-${var.system}-s3-sink-connector-role"
    Environment = var.env
    System      = var.system
  }
}

resource "aws_iam_role_policy_attachment" "connector" {
  policy_arn = aws_iam_policy.connector.arn
  role       = aws_iam_role.s3_connect_role.name
}

resource "aws_iam_policy" "connector" {
  name   = "${var.account}-iam-${var.env}-${var.system}-s3-sink-connector-role-policy"
  policy = data.aws_iam_policy_document.s3_connector_role_assume_role_policy.json
  tags = {
    Name        = "${var.account}-iam-${var.env}-${var.system}-s3-sink-connector-role-policy"
    Environment = var.env
    System      = var.system
  }
}

data "aws_iam_policy_document" "s3_connector_role_assume_role_policy" {

  statement {
    sid       = "AllowListAllBuckets"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]
    actions = [
      "s3:ListAllMyBuckets"
    ]
  }

  statement {
    sid       = "AllowSpecificBucketActions"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*rddi-data-platform-raw"]
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:DeleteObject"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads"
    ]
    resources = ["*"]
  }
}