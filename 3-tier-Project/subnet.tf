resource "azurerm_subnet" "subnet01-vnethub" {
  name                 = "virtualappliance-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnethub.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "subnet-appgw-vnethub" {
  name                 = "application-gw-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnethub.name
  address_prefixes     = ["10.0.0.0/24"]
}



resource "azurerm_subnet" "subnet01-vnetfrontend" {
  name                 = "vnet-frontend-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnetfrontend.name
  address_prefixes     = ["172.16.0.0/24"]
}



resource "azurerm_subnet" "subnet01-vnetbackend" {
  name                 = "vnet-backend-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnetbackend.name
  address_prefixes     = ["192.168.0.0/24"]
}



resource "azurerm_subnet" "subnet01-vnetdatabase" {
  name                 = "vnet-database-subnet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnetdatabase.name
  address_prefixes     = ["11.0.0.0/24"]
}
