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
variable "cpu_utilization_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "connection_alerts" {
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

variable "burst_balance_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "queue_depth_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "read_iops_alerts" {
  type        = "map"
  description = "(Optional) ..."
  default     = {}
}

variable "write_iops_alerts" {
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

// DB CONNECTIONS
module "connections" {
  source        = "./metrics/connections"
  should_create = length(var.connection_alerts) > 0
  config = merge(local.default_config, {
    alerts = var.connection_alerts
  })
}

// FREE STORAGE
module "free_storage" {
  source        = "./metrics/free_storage"
  should_create = length(var.free_storage_alerts) > 0
  config = merge(local.default_config, {
    comparison = "below"
    alerts     = var.free_storage_alerts
  })
}

// FREE MEMORY
module "free_memory" {
  source        = "./metrics/free_memory"
  should_create = length(var.free_memory_alerts) > 0
  config = merge(local.default_config, {
    comparison = "below"
    alerts     = var.free_memory_alerts
  })
}

// BURST BALANCE
module "burst_balance" {
  source        = "./metrics/burst_balance"
  should_create = length(var.burst_balance_alerts) > 0
  config = merge(local.default_config, {
    comparison = "below"
    alerts     = var.burst_balance_alerts
  })
}

// QUEUE DEPTH
module "queue_depth" {
  source        = "./metrics/queue_depth"
  should_create = length(var.queue_depth_alerts) > 0
  config = merge(local.default_config, {
    alerts = var.queue_depth_alerts
  })
}

// READ IOPS
module "read_iops" {
  source        = "./metrics/read_iops"
  should_create = length(var.read_iops_alerts) > 0
  config = merge(local.default_config, {
    alerts = var.read_iops_alerts
  })
}

// WRITE IOPS
module "write_iops" {
  source        = "./metrics/write_iops"
  should_create = length(var.write_iops_alerts) > 0
  config = merge(local.default_config, {
    alerts = var.write_iops_alerts
  })
}

################################################################################
# OUTPUTS
################################################################################
