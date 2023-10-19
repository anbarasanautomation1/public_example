locals {
  tags_common = merge(var.tags_extra, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  })
  name_prefix = "${var.project}-${var.environment}"
  env = {
    default = {
      location          = "australiasoutheast"
      backend_image     = "backend"
      backend_image_tag = "1.0.0"
      backend_port      = 3000
      backend_domain    = "${var.environment}.${var.project}.com"
    }
    dev = {
    }
    qa = {
    }
    prod = {
      backend_domain = "${var.project}.com"
    }
  }
  workspace       = contains(keys(local.env), var.environment) ? var.environment : "default"
  environmentvars = merge(local.env["default"], local.env[local.workspace])
}
