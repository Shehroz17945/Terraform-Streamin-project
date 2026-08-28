resource "azurerm_virtual_network_peering" "hub-frontend" {

  name                         = "hub_to_frontend"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnethub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnetfrontend.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "frontend-hub" {

  name                         = "frontend_to_hub"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnetfrontend.name
  remote_virtual_network_id    = azurerm_virtual_network.vnethub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "hub-backend" {
  name                         = "hub_to_backend"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnethub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnetbackend.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}
resource "azurerm_virtual_network_peering" "backend-hub" {
  name                         = "backend_to_hub"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnetbackend.name
  remote_virtual_network_id    = azurerm_virtual_network.vnethub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "hub-database" {
  name                         = "hub_to_database"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnethub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnetdatabase.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "database-hub" {
  name                         = "database_to_hub"
  resource_group_name          = azurerm_resource_group.rg01.name
  virtual_network_name         = azurerm_virtual_network.vnetdatabase.name
  remote_virtual_network_id    = azurerm_virtual_network.vnethub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
