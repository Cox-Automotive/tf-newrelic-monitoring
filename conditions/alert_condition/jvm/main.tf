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
resource "newrelic_alert_condition" "alert" {
  count     = var.should_create ? 1 : 0
  policy_id = var.config["alert_policy_id"]
  name      = var.config["name"]
  type      = "apm_jvm_metric"

  entities              = var.config["app_ids"]
  metric                = var.config["metric"]
  violation_close_timer = 24

  dynamic "term" {
    for_each = [for k, v in var.config["alerts"] : {
      duration      = v.duration
      operator      = v.operator
      priority      = k
      threshold     = v.threshold
      time_function = v.time_function
    }]

    content {
      duration      = term.value.duration
      operator      = term.value.operator
      priority      = term.value.priority
      threshold     = term.value.threshold
      time_function = term.value.time_function
    }
  }
}
