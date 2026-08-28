locals {
  port_name             = "frontend_port_01"
  frontend_ip_name      = "frontend_ip-01"
  frontend_adress_pool  = "frontend-address-pool"
  backend_address_pool  = "backend-address-pool"
  listener_name         = "listener-01"
  frontend_http_setting = "frontend-http-seeting"
  backend_http_setting  = "backend-http-setting"
}

resource "azurerm_application_gateway" "app-gw-hub" {
  name                = "appgateway-hub"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet-appgw-vnethub.id
  }

  frontend_port {
    name = local.port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.pip01-app-gw.id
  }

  backend_address_pool {
    name         = local.frontend_adress_pool
    ip_addresses = [azurerm_network_interface.nic01-frontend.private_ip_address]
  }

  backend_address_pool {
    name         = local.backend_address_pool
    ip_addresses = [azurerm_network_interface.nic01-backend.private_ip_address]
  }

  backend_http_settings {
    name                  = local.frontend_http_setting
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # Custom Probe (Fixes 404 Unhealthy Issue)
  probe {
    name                = "backend-health-probe"
    protocol            = "Http"
    path                = "/"
    interval            = 15
    timeout             = 15
    unhealthy_threshold = 3
    host                = "127.0.0.1"

    match {
      status_code = ["200-399", "404"]
    }
  }

  backend_http_settings {
    name                  = local.backend_http_setting
    cookie_based_affinity = "Disabled"
    port                  = 5000
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "backend-health-probe" 
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_name
    frontend_port_name             = local.port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name               = "request-routing-rule-01"
    priority           = 100
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_name
    url_path_map_name  = "url-path-map-01"
  }

  url_path_map {
    name                               = "url-path-map-01"
    default_backend_address_pool_name  = local.frontend_adress_pool
    default_backend_http_settings_name = local.frontend_http_setting

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api", "/api/*"]
      backend_address_pool_name  = local.backend_address_pool
      backend_http_settings_name = local.backend_http_setting
    }
  }
}