resource "azurerm_resource_group" "hub" {
  name     = "${local.name_prefix}-hub"
  location = local.environmentvars["location"]
}

resource "azurerm_resource_group" "backend-app" {
  name     = "${local.name_prefix}-backend"
  location = local.environmentvars["location"]
}
