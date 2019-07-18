################################################################################
# VARIABLES
################################################################################
// REQUIRED
variable "config" []

// OPTIONAL
variable "should_create" {
  default = true
}

################################################################################
# RESOURCES
################################################################################
module "alert_condition" {
  source = "../../../../../conditions/alert_condition/synthetic"

  should_create = var.should_create
  config = {
    synthetic_type = ""
    name           = ""
    locations      = ""
    status         = ""
    sla_threshold  = ""

    type_config = {
      uri = ""
      validation_string = ""
      verify_ssl = ""
      bypass_head_request = ""
      fail_on_redirect = ""
    }
  }
}
resource "newrelic_synthetics_monitor" "monitor" {
  count = var.should_create ? 1 : 0
  type      = var.config["synthetic_type"] //required; ping == simple
  name      = var.config["name"] //required
  frequency = var.config["frequency"] //required
  locations = local.translated_locations
  status    = var.config["status"] // required

  sla_theshold = var.config["sla_threshold"] //optional

  // valid only if type == simple|browser
  uri                         = var.config["uri"] // optional
  validation_string           = var.config["validation_string"] //optional
  verify_ssl                  = var.config["verify_ssl"] //optional
  bypass_head_request         = var.config["bypass_head_request"] //optional
  treat_redirected_as_failure = var.config["fail_on_redirect"] //optional
}

resource "newrelic_synthetics_alert_condition" "alert" {
  count = var.should_create ? 1 : 0

  policy_id   = var.config["alert_policy_id"]
  name        = var.config["name"]
  monitor_id  = newrelic_synthetics_monitor.monitor.0.id
  runbook_url = var.config["runbook_url"]
}
