variable "env" {
  description = "environment name"
  type        = string
}

variable "system" {
  type = string
}

variable "account" {
  description = "account name"
  type        = string
  default     = "nihrd"
}

variable "s3_connector_bucket" {
  description = "S3 connector bucket name"
  type        = string
}

variable "custom_plugin_name" {
  description = "S3 sink connector custom plugin name"
  type        = string
}

variable "connect_name" {
  description = "connect name"
  type        = string
}

variable "private_subnet_ids" {

}

variable "bootstrap_servers" {

}

variable "msk_security_group" {

}

variable "retention_in_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}