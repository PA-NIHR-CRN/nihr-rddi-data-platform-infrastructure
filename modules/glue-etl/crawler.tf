data "aws_iam_policy_document" "crawler_assume_role" {
  statement {
    sid    = "GlueAsumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "crawler_permissions" {
  statement {
    sid    = "CrawlerAccess"
    effect = "Allow"
    actions = [
        "glue:GetCrawler",
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:CreateTable",
        "glue:StartCrawler",
        "glue:UpdateCrawler"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "glue_crawler_role" {
  name               = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role.json
  inline_policy {
    name   = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-crawler-policy"
    policy = data.aws_iam_policy_document.crawler_permissions.json
  }
}

resource "aws_glue_workflow" "workflow" {
  name = "nihrd-glue-${var.env}-${var.system}-${var.stage}-workflow"
}

resource "aws_glue_trigger" "workflow_trigger" {
  name          = "nihrd-glue-${var.env}-${var.system}-${var.stage}-workflow-trigger"
  type          = "ON_DEMAND"
  workflow_name = aws_glue_workflow.workflow.name

  actions {
    crawler_name = aws_glue_crawler.crawler.name
  }
}

resource "aws_glue_catalog_database" "database" {
  name = "nihrd-glue-${var.env}-${var.system}-${var.stage}-database"

  create_table_default_permission {
    permissions = ["SELECT"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}

resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.database.name
  name          = "nihrd-glue-${var.env}-${var.system}-${var.stage}-crawler"
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://${var.target_bucket}/"
  }
}