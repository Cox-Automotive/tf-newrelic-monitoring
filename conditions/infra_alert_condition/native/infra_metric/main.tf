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
  count      = var.should_create ? 1 : 0
  policy_id  = var.config["alert_policy_id"]
  name       = var.config["name"]
  type       = "infra_metric"
  event      = var.config["event"]
  select     = var.config["select"]
  comparison = var.config["comparison"]
  where      = var.config["where"]

  dynamic "critical" {
    for_each = [for k, v in var.config["alerts"] : {
      duration      = v.duration
      value         = v.value
      time_function = v.time_function
    } if k == "critical"]

    content {
      duration      = critical.value.duration
      value         = critical.value.value
      time_function = critical.value.time_function
    }
  }

  dynamic "warning" {
    for_each = [for k, v in var.config["alerts"] : {
      duration      = v.duration
      value         = v.value
      time_function = v.time_function
    } if k == "warning"]

    content {
      duration      = warning.value.duration
      value         = warning.value.value
      time_function = warning.value.time_function
    }
  }
}
