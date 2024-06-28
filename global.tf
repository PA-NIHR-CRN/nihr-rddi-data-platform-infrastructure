variable "names" {
  default = {
    "retention_in_days" = "30"
    "proj"              = "nihr"
    "system"            = "rddi-data-platform"
    "app"               = "rddi-data-platform"

    "dev" = {
      "accountidentifiers" = "nihrd"
      "environment"        = "dev"
      "app"                = "rddi-data-platform"
      "bucket_name"        = "nihrd-s3-dev-rddi-data-platform-raw"
      "bucket_name_bronze" = "nihrd-s3-dev-rddi-data-platform-bronze"
      "bucket_name_silver" = "nihrd-s3-dev-rddi-data-platform-silver"
      "bucket_name_gold"   = "nihrd-s3-dev-rddi-data-platform-gold"

      "lambda_name_raw_convert" = "raw-convert"
    }
  }
}