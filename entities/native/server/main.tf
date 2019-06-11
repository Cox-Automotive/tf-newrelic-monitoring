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
variable "new_relic_app_id" {
  description = "(Optional) ..."
  default     = ""
}

variable "cpu_utilization_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "free_storage_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}


variable "free_memory_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "qualys_process_running_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "splunk_process_running_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "jvm_heap_alerts" {
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
  source        = "./metrics/cpu_utilization"
  should_create = length(var.cpu_utilization_alerts) > 0
  config = merge(local.default_config, {
    alerts = var.cpu_utilization_alerts
  })
}

// FREE STORAGE
module "free_storage" {
  source        = "./metrics/free_storage"
  should_create = length(var.free_storage_alerts) > 0
  config = merge(local.default_config, {
    alerts     = var.free_storage_alerts
    comparison = "below"
  })
}

// FREE MEMORY
module "free_memory" {
  source        = "./metrics/free_memory"
  should_create = length(var.free_memory_alerts) > 0
  config = merge(local.default_config, {
    alerts     = var.free_memory_alerts
    comparison = "below"
  })
}

// QUALYS PROCESS RUNNING
module "qualys_process_running" {
  source        = "./metrics/process_running"
  should_create = length(var.qualys_process_running_alerts) > 0
  config = merge(local.default_config, {
    process       = "Qualys"
    process_where = "(`processDisplayName` = 'qualys-cloud-agent')"
    alerts        = var.qualys_process_running_alerts
    comparison    = "below"
  })
}

// SPLUNK PROCESS RUNNING
module "splunk_process_running" {
  source        = "./metrics/process_running"
  should_create = length(var.splunk_process_running_alerts) > 0
  config = merge(local.default_config, {
    process       = "Splunk"
    process_where = "(`commandName` = 'splunkd')"
    alerts        = var.splunk_process_running_alerts
    comparison    = "below"
  })
}

// JVM HEAP
module "jvm_heap" {
  source        = "./metrics/jvm_heap"
  should_create = length(var.jvm_heap_alerts) > 0

  config = merge(local.default_config, {
    alerts     = var.jvm_heap_alerts
    comparison = "below"
    app_ids    = list(var.new_relic_app_id)
  })
}
