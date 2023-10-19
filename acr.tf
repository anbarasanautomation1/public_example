resource "azurerm_container_registry" "registry" {
  count = var.environment == "dev" ? 1 : 0

  name                = "${var.project}registry" # Must be alphanumeric
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  sku                 = "Standard"
  admin_enabled       = true # required for App Service
}
