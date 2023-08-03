resource "shoreline_notebook" "low_postgresql_commit_rate_incident" {
  name       = "low_postgresql_commit_rate_incident"
  data       = file("${path.module}/data/low_postgresql_commit_rate_incident.json")
  depends_on = [shoreline_action.invoke_disk_monitor,shoreline_action.invoke_check_long_queries,shoreline_action.invoke_config_check_and_remediate]
}

resource "shoreline_file" "disk_monitor" {
  name             = "disk_monitor"
  input_file       = "${path.module}/data/disk_monitor.sh"
  md5              = filemd5("${path.module}/data/disk_monitor.sh")
  description      = "Check disk usage and I/O performance"
  destination_path = "/agent/scripts/disk_monitor.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_long_queries" {
  name             = "check_long_queries"
  input_file       = "${path.module}/data/check_long_queries.sh"
  md5              = filemd5("${path.module}/data/check_long_queries.sh")
  description      = "Check if there are any long-running queries that may be causing a bottleneck. Identify the queries and tune them or optimize the database schema."
  destination_path = "/agent/scripts/check_long_queries.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_check_and_remediate" {
  name             = "config_check_and_remediate"
  input_file       = "${path.module}/data/config_check_and_remediate.sh"
  md5              = filemd5("${path.module}/data/config_check_and_remediate.sh")
  description      = "Check if there are any configuration issues with the Postgresql server. Verify the configuration settings and make any necessary changes."
  destination_path = "/agent/scripts/config_check_and_remediate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_disk_monitor" {
  name        = "invoke_disk_monitor"
  description = "Check disk usage and I/O performance"
  command     = "`chmod +x /agent/scripts/disk_monitor.sh && /agent/scripts/disk_monitor.sh`"
  params      = ["DISK"]
  file_deps   = ["disk_monitor"]
  enabled     = true
  depends_on  = [shoreline_file.disk_monitor]
}

resource "shoreline_action" "invoke_check_long_queries" {
  name        = "invoke_check_long_queries"
  description = "Check if there are any long-running queries that may be causing a bottleneck. Identify the queries and tune them or optimize the database schema."
  command     = "`chmod +x /agent/scripts/check_long_queries.sh && /agent/scripts/check_long_queries.sh`"
  params      = ["DATABASE_USER","DATABASE_PASSWORD","DATABASE_NAME","DATABASE_HOST","DATABASE_PORT"]
  file_deps   = ["check_long_queries"]
  enabled     = true
  depends_on  = [shoreline_file.check_long_queries]
}

resource "shoreline_action" "invoke_config_check_and_remediate" {
  name        = "invoke_config_check_and_remediate"
  description = "Check if there are any configuration issues with the Postgresql server. Verify the configuration settings and make any necessary changes."
  command     = "`chmod +x /agent/scripts/config_check_and_remediate.sh && /agent/scripts/config_check_and_remediate.sh`"
  params      = []
  file_deps   = ["config_check_and_remediate"]
  enabled     = true
  depends_on  = [shoreline_file.config_check_and_remediate]
}

