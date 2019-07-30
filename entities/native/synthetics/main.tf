################################################################################
# VARIABLES
################################################################################

variable "simple_synthetics_monitoring" {
  description = "(OPTIONAL) ..."
  default     = {}
}

################################################################################
# RESOURCES
################################################################################

module "simple_synthetics_monitoring" {
  source        = "./simple/"
  should_create = length(var.simple_synthetics_monitoring) > 0
  config        = var.simple_synthetics_monitoring
}
