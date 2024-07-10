resource "aws_mskconnect_connector" "connector" {
  name = var.connect_name

  kafkaconnect_version = "2.7.1"

  capacity {
    provisioned_capacity {
      mcu_count    = 1
      worker_count = 1
    }
  }

  connector_configuration = {
    "connector.class"            = "io.confluent.connect.s3.S3SinkConnector"
    "s3.region"                  = "eu-west-2"
    "topics.dir"                 = "dev"
    "flush.size"                 = "1"
    "schema.compatibility"       = "NONE"
    "tasks.max"                  = "2"
    "topics"                     = "nihrd-msk-dev-study-management-topic"
    "format.class"               = "io.confluent.connect.s3.format.bytearray.ByteArrayFormat"
    "partitioner.class"          = "io.confluent.connect.storage.partitioner.DefaultPartitioner"
    "format.bytearray.extension" = ".json"
    "value.converter"            = "org.apache.kafka.connect.converters.ByteArrayConverter"
    "storage.class"              = "io.confluent.connect.s3.storage.S3Storage"
    "s3.bucket.name"             = "nihrd-s3-dev-rddi-data-platform-raw"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = var.bootstrap_servers

      vpc {
        security_groups = var.msk_security_group
        subnets         = var.private_subnet_ids
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.plugin.arn
      revision = aws_mskconnect_custom_plugin.plugin.latest_revision
    }
  }

  service_execution_role_arn = aws_iam_role.s3_connect_role.arn

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.sink_connector_log_group.name
      }
    }
  }
  depends_on = [aws_mskconnect_custom_plugin.plugin]
}

# logging
resource "aws_cloudwatch_log_group" "sink_connector_log_group" {
  name              = aws_mskconnect_connector.connector.name
  retention_in_days = var.retention_in_days
  tags = {
    Name        = "${aws_mskconnect_connector.connector.name}"
    Environment = var.env
    System      = var.system
  }
}