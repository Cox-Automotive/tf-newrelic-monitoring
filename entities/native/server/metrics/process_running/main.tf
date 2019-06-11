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
module "alert_condition" {
  source        = "../../../../../conditions/infra_alert_condition/native/infra_process_running"
  should_create = var.should_create
  config = {
    alert_policy_id = var.config["alert_policy_id"]
    name            = "Server - Process Running - ${var.config["process"]}"
    event           = "ProcessSample"
    comparison      = var.config["comparison"]
    where           = var.config["where"]
    alerts          = var.config["alerts"]
    process_where   = var.config["process_where"]
  }
}
