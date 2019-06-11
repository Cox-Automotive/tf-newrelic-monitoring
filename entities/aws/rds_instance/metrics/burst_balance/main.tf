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
  source        = "../../../../../conditions/infra_alert_condition/integration"
  should_create = var.should_create
  config = {
    alert_policy_id      = var.config["alert_policy_id"]
    name                 = "RDS - Low burst balance"
    integration_provider = "RdsDbInstance"
    select               = "provider.burstBalance.Minimum"
    comparison           = var.config["comparison"]
    where                = var.config["where"]
    alerts               = var.config["alerts"]
  }
}
