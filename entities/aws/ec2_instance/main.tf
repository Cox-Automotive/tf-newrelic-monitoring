################################################################################
# VARIABLES
################################################################################
// REQUIRED
variable "new_relic_alert_policy" {
  description = "(Required) ..."
}

variable "where" {
  type        = "string"
  description = "(Required) ..."
}

// OPTIONAL
variable "cpu_credits_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

// LOCAL VARIABLES
locals {
  alert_policy = var.new_relic_alert_policy
  default_config = {
    alert_policy_id = local.alert_policy.id
    where           = var.where
    comparison      = "above"
  }
}

################################################################################
# RESOURCES
################################################################################
// CPU UTILIZATION
module "cpu_utilization" {
  source        = "./metrics/cpu_credits"
  should_create = length(var.cpu_credits_alerts) > 0
  config = merge(local.default_config, {
    comparison = "below"
    alerts     = var.cpu_credits_alerts
  })
}
