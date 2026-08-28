resource "azurerm_public_ip" "pip01-appliance" {
  name                = "pip-01-appliance"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_public_ip" "pip01-app-gw" {
  name                = "pip-01-app-gw"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  allocation_method   = "Static"
  domain_name_label = "streamvault"
}