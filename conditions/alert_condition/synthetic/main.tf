################################################################################
# VARIABLES
################################################################################
variable "config" []
variable "should_create" {
  default = true
}

locals {
  location_map = {
    // ASIA
    "Tokyo, JP"     = "AWS_AP_NORTHEAST_1"
    "Singapore, SG" = "AWS_AP_SOUTHEAST_1"
    "Mumbai, IN"    = "AWS_AP_SOUTH_1"
    "Seoul, KR"     = "AWS_AP_NORTHEAST_2"

    // NORTH AMERICA
    "Dallas, TX, USA"        = "LINODE_US_CENTRAL_1"
    "Portland, OR, USA"      = "AWS_US_WEST_2"
    "Montreal, Québec, CA"   = "AWS_CA_CENTRAL_1"
    "Colmubus, OH, USA"      = "AWS_US_EAST_2"
    "Newark, NJ, USA"        = "LINODE_US_EAST_1"
    "San Francisco, CA, USA" = "AWS_US_WEST_1"
    "Washington DC, USA"     = "AWS_US_EAST_1"
    "Fremont, CA, USA"       = "LINODE_US_WEST_1"

    // EUROPE
    "Dublin, IE"          = "AWS_EU_WEST_1"
    "London, England, UK" = "AWS_EU_WEST_2"
    "Frankfurt, DE"       = "AWS_EU_CENTRAL_1"
    "Paris, FR"           = "AWS_EU_WEST_3"

    // AUSTRALIA
    "Sydney, AU" = "AWS_AP_SOUTHEAST_2"

    // SOUTH AMERICA
    "São Paulo, BR" = "AWS_SA_EAST_1"
  }
  translated_locations = [for l in var.config["locations"] : lookup(local.location_map, l)]
  type_map = {
    "PING" = "SIMPLE"
  }
  translated_type = lookup(local.type_map, var.config["type"], var.config["type"])
}

################################################################################
# RESOURCES
################################################################################
resource "newrelic_synthetics_monitor" "monitor" {
  count = var.should_create ? 1 : 0
  type      = var.config["synthetic_type"] //required; ping == simple
  name      = var.config["name"] //required
  frequency = var.config["frequency"] //required
  locations = local.translated_locations
  status    = var.config["status"] // required

  sla_threshold = var.config["sla_threshold"] //optional

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
