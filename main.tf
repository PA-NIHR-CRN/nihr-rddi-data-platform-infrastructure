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

module "s3_bucket_raw" {
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
  arn = module.s3_bucket_raw.bucket_arn
}

module "raw_processor_ecr" {
  source    = "./modules/ecr"
  repo_name = "${var.names["${var.env}"]["accountidentifiers"]}-ecr-${var.env}-${var.names["system"]}"
  env       = var.env
  app       = var.names["${var.env}"]["app"]
}

module "s3_sink_connector" {
  source              = "./modules/s3-sink-connector"
  s3_connector_bucket = module.s3_bucket_raw
  env                 = var.env
  system              = var.names["system"]
  custom_plugin_name  = var.names["${var.env}"]["custom_plugin_name"]
  connect_name        = var.names["${var.env}"]["connect_name"]
  private_subnet_ids  = var.names["${var.env}"]["private_subnet_ids"]
  bootstrap_servers   = var.names["${var.env}"]["bootstrap_servers"]
  msk_security_group  = var.names["${var.env}"]["msk_security_group"]
  retention_in_days   = var.names["${var.env}"]["retention_in_days"]

}