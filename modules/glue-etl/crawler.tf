data "aws_iam_policy_document" "crawler_assume_role" {
  statement {
    sid    = "GlueAsumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com", "events.amazonaws.com"]
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
      "glue:CreateDatabase",
      "glue:UpdateDatabase",
      "glue:GetTable",
      "glue:CreateTable",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:StartCrawler",
      "glue:UpdateCrawler"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "glue_crawler_role" {
  count              = var.enable_crawler ? 1 : 0
  name               = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role.json
  inline_policy {
    name   = "nihrd-iam-${var.env}-${var.system}-${var.stage}-glue-crawler-policy"
    policy = data.aws_iam_policy_document.crawler_permissions.json
  }
}

resource "aws_glue_workflow" "workflow" {
  count = var.enable_crawler ? 1 : 0
  name  = "nihrd-glue-${var.env}-${var.system}-${var.stage}-workflow"
}

resource "aws_glue_trigger" "workflow_trigger" {
  count         = var.enable_crawler ? 1 : 0
  name          = "nihrd-glue-${var.env}-${var.system}-${var.stage}-workflow-trigger"
  type          = "EVENT"
  workflow_name = aws_glue_workflow.workflow[0].name

  actions {
    crawler_name = aws_glue_crawler.crawler[0].name
  }
}

resource "aws_glue_catalog_database" "database" {
  count = var.enable_crawler ? 1 : 0
  name  = "nihrd-glue-${var.env}-${var.system}-${var.stage}-database"

  create_table_default_permission {
    permissions = ["SELECT","ALTER","DROP", "CREATE_TABLE","CREATE_DATABASE"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}

resource "aws_glue_crawler" "crawler" {
  count         = var.enable_crawler ? 1 : 0
  database_name = aws_glue_catalog_database.database[0].name
  name          = "nihrd-glue-${var.env}-${var.system}-${var.stage}-crawler"
  role          = aws_iam_role.glue_crawler_role[0].arn

  s3_target {
    path = "s3://${var.target_bucket}/"
  }
}