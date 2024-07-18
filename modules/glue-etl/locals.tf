locals {
  script_bucket_name = "nihrd-s3-${var.env}-${var.system}-glue-scripts"
  script_endpoint = "s3://${local.script_bucket_name}/${aws_s3_object.script.key}"
  image_uri = "462580661309.dkr.ecr.eu-west-2.amazonaws.com/nihrd-ecr-rddi-dp-glue-router:latest"
  func_name = "nihrd-lambda-${var.env}-${var.system}-${var.stage}-function"
  glue_job_name = "nihrd-glue-${var.env}-${var.system}-${var.stage}-job"
  ebr_event_source_created = "nihrd-ebr-${var.env}-${var.system}-${var.stage}-trigger"
  default_tags = {
    "Enviroment": var.env,
    "System": var.system,
  }

  install_deps = length(var.install_deps) > 0 ? var.install_deps : []
}