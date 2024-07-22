resource "aws_s3_bucket" "scripts_bucket" {
  count  = var.create_script_bucket ? 1 : 0
  bucket = local.script_bucket_name
  tags_all = merge(local.default_tags, {
    "Name" : local.script_bucket_name
  })
}

resource "aws_s3_object" "script" {
  bucket = local.script_bucket_name
  key    = "${var.env}/${local.glue_job_name}/script.py"
  source = var.script_template
  tags_all = merge(local.default_tags, {
    "Name" : local.script_bucket_name,
  })
}