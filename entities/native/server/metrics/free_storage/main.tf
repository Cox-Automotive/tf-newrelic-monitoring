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
  source        = "../../../../../conditions/infra_alert_condition/native/infra_metric"
  should_create = var.should_create
  config = {
    alert_policy_id = var.config["alert_policy_id"]
    name            = "Server - Low Free Storage"
    type            = "infra_metric"
    event           = "StorageSample"
    select          = "diskFreePercent"
    comparison      = var.config["comparison"]
    where           = var.config["where"]
    alerts          = var.config["alerts"]
  }
}
