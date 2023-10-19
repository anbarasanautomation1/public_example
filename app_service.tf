resource "azurerm_app_service_plan" "backend" {
  name                = "${local.name_prefix}-backend-appserviceplan"
  location            = azurerm_resource_group.backend-app.location
  resource_group_name = azurerm_resource_group.backend-app.name
  kind                = "Linux"
  reserved            = true # required for Linux plans, might need to be in a properties thing
  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "backend" {
  name                = "${local.name_prefix}-backend-app-service"
  location            = azurerm_resource_group.backend-app.location
  resource_group_name = azurerm_resource_group.backend-app.name
  app_service_plan_id = azurerm_app_service_plan.backend.id
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = azurerm_container_registry.registry.0.login_server
    DOCKER_REGISTRY_SERVER_USERNAME     = azurerm_container_registry.registry.0.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = azurerm_container_registry.registry.0.admin_password
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    WEBSITES_PORT                       = local.environmentvars["backend_port"]
  }

  site_config {
    always_on = "true"
    # define the images to used for you application
    linux_fx_version = "DOCKER|${azurerm_container_registry.registry.0.login_server}/${local.environmentvars["backend_image"]}:${local.environmentvars["backend_image_tag"]}"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_custom_hostname_binding" "backend" {
  hostname            = local.environmentvars["backend_domain"]
  app_service_name    = azurerm_app_service.backend.name
  resource_group_name = azurerm_resource_group.backend-app.name

  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "backend" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.backend.id
}

resource "azurerm_app_service_certificate_binding" "backend" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.backend.id
  certificate_id      = azurerm_app_service_managed_certificate.backend.id
  ssl_state           = "SniEnabled"
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_app_service.backend.identity.0.principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.registry.0.id
  skip_service_principal_aad_check = true
}
