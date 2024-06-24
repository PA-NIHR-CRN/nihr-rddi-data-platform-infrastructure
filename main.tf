terraform {
  backend "s3" {
    region  = "eu-west-2"
    encrypt = true
  }

}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.names["${var.env}"]["bucket_name"]
  env         = var.env
  system      = var.names["system"]
}

module "s3_bucket_bronze" {
  source      = "./modules/s3"
  bucket_name = var.names["${var.env}"]["bucket_name_bronze"]
  env         = var.env
  system      = var.names["system"]
}

module "s3_bucket_silver" {
  source      = "./modules/s3"
  bucket_name = var.names["${var.env}"]["bucket_name_silver"]
  env         = var.env
  system      = var.names["system"]
}

module "s3_bucket_gold" {
  source      = "./modules/s3"
  bucket_name = var.names["${var.env}"]["bucket_name_gold"]
  env         = var.env
  system      = var.names["system"]
}

resource "aws_lakeformation_resource" "example" {
  arn = module.s3_bucket.bucket_arn
}

module "raw_convert_lambda" {
  source = "./modules/dp-lambda-raw"
  name = var.names["${var.env}"]["lambda_name_raw_convert"]
  target_bucket = var.names["${var.env}"]["bucket_name_bronze"]
  source_bucket = var.names["${var.env}"]["bucket_name"]
  env = var.env
  system = var.names["system"]
}