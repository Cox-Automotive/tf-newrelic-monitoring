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
    name                 = "EC2 - Low CPU Credits"
    integration_provider = "Ec2Instance"
    select               = "provider.cpuCreditUsage.Average/provider.cpuCreditBalance.Average*100"
    comparison           = var.config["comparison"]
    where                = var.config["where"]
    alerts               = var.config["alerts"]
  }
}
