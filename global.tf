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
    }
  }
}