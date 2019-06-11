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
  source = "../../../../../conditions/infra_alert_condition/integration"
  config = {
    alert_policy_id      = var.config["alert_policy_id"]
    name                 = "RDS - High CPU usage"
    integration_provider = "RdsDbInstance"
    select               = "provider.cpuUtilization.Average"
    comparison           = "above"
    where                = var.config["where"]
    alerts               = var.config["alerts"]
  }
}
