resource "aws_glue_catalog_database" "database" {
  count = var.enable_data_catalog ? 1 : 0
  name  = "nihrd-glue-${var.env}-${var.system}-${var.stage}-database"

  create_table_default_permission {
    permissions = ["SELECT","ALTER","DROP", "CREATE_TABLE","CREATE_DATABASE"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}
