################################################################################
# VARIABLES
################################################################################
// REQUIRED
variable "config" {}

// OPTIONAL
variable "should_create" {
  default = true
}

################################################################################
# RESOURCES
################################################################################
module "alert_condition" {
  source        = "../../../../../conditions/alert_condition/jvm"
  should_create = var.should_create
  config = {
    alert_policy_id = var.config["alert_policy_id"]
    name            = "Server - Low Available Heap - JVM"
    app_ids         = var.config["app_ids"]
    metric          = "heap_memory_usage"
    alerts          = var.config["alerts"]
  }
}
