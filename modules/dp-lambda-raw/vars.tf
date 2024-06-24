variable "name" {
    type = string
    default = "raw-ingestion"
}

variable "image" {
    type = string
    default = "462580661309.dkr.ecr.eu-west-2.amazonaws.com/nihrd-ecr-dev-rddi-raw-ingestion:latest"
}

variable "source_bucket" {
  type = string
}

variable "target_bucket" {
  type = string
}

variable "env" {}

variable "system" {}