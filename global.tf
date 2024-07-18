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
      "custom_plugin_name" = "nihrd-dev-rddi-data-platform-s3-sink-connector-plugin"
      "connect_name"       = "nihrd-s3-dev-rddi-data-platform-connect"
      "private_subnet_ids" = ["subnet-036934130e6e171db", "subnet-08301b8a8d127a1e5"]
      "bootstrap_servers"  = "b-1.nihrdmskdevnsipcluster.z2kr4f.c2.kafka.eu-west-2.amazonaws.com:9094,b-2.nihrdmskdevnsipcluster.z2kr4f.c2.kafka.eu-west-2.amazonaws.com:9094"
      "msk_security_group" = ["sg-0b80f3f34f0a80e31"]
      "retention_in_days"  = 30
    }
  }
}