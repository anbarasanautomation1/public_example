variable "region" {
  description = "Azure region to create infrastructure in"
  default     = "East-US"
}
variable "project" {
  description = "The project name"
  default     = "example"
}
variable "environment" {
  description = "The project environment"
  default     = "dev"
}
variable "tags_extra" {
  type        = map(string)
  description = "Extra tags that should be applied to all resources"
  default     = {}
}

variable "ARM_CLIENT_ID" {}

variable "ARM_CLIENT_SECRET" {}

variable "ARM_SUBSCRIPTION_ID" {}

variable "ARM_TENANT_ID" {}
