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

output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The ARN of the created S3 bucket"
}

resource "aws_lakeformation_resource" "example" {
  arn = module.s3_bucket.bucket_arn
}