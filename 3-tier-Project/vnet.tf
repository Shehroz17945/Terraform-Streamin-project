resource "azurerm_virtual_network" "vnethub" {

  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
}


resource "azurerm_virtual_network" "vnetfrontend" {

  name                = "vnet-frontend"
  address_space       = ["172.16.0.0/16"]
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
}

resource "azurerm_virtual_network" "vnetbackend" {

  name                = "vnet-backend"
  address_space       = ["192.168.0.0/16"]
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
}

resource "azurerm_virtual_network" "vnetdatabase" {

  name                = "vnet-database"
  address_space       = ["11.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
}
