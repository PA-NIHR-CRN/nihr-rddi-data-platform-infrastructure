variable "stage" {
  type = string
  default = "test"
}

variable "script_template" {
  type = string
  description = "path to python script to use for glue job. A new instance of this script is created for each instance of the module"
  default = "./script/base.py"
}

variable "source_bucket" {
  type = string
  description = "sucket source for events"
}

variable "target_bucket" {
  type = string
}

variable "create_script_bucket" {
  type = bool
}

variable "env" {}

variable "system" {}

variable "accountId" {
  type = string
  default = "462580661309"
}

variable "region" {
  type = string
  default = "eu-west-2"
}

