################################################################################
# VARIABLES
################################################################################
variable "config" {}
variable "should_create" {
  default = true
}

################################################################################
# RESOURCES
################################################################################
resource "newrelic_infra_alert_condition" "alert" {
  count         = var.should_create ? 1 : 0
  policy_id     = var.config["alert_policy_id"]
  name          = var.config["name"]
  type          = "infra_process_running"
  event         = var.config["event"]
  comparison    = var.config["comparison"]
  where         = var.config["where"]
  process_where = var.config["process_where"]

  dynamic "critical" {
    for_each = [for k, v in var.config["alerts"] : {
      duration = v.duration
      value    = v.value
    } if k == "critical"]

    content {
      duration = critical.value.duration
      value    = critical.value.value
    }
  }

  dynamic "warning" {
    for_each = [for k, v in var.config["alerts"] : {
      duration = v.duration
      value    = v.value
    } if k == "warning"]

    content {
      duration = warning.value.duration
      value    = warning.value.value
    }
  }
}
