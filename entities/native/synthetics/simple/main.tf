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
  source = "../../../../conditions/alert_condition/synthetic"

  should_create = var.should_create
  config = {
    type      = "SIMPLE"
    name      = "${var.config["name"]} - Login Page"
    frequency = var.config["frequency"]
    locations = var.config["locations"]
    status    = var.config["status"]

    sla_threshold = lookup(var.config, "sla_threshold", 7)

    type_config = {
      uri                 = var.config["uri"]
      validation_string   = lookup(var.config, "validation_string", "")
      verify_ssl          = lookup(var.config, "verify_ssl", false)
      bypass_head_request = lookup(var.config, "bypass_head_request", false)
      fail_on_redirect    = lookup(var.config, "fail_on_redirect", false)
    }

    alert_policy_id = var.config["alert_policy_id"]
    runbook_url     = lookup(var.config, "runbook_url", "")
  }
}
