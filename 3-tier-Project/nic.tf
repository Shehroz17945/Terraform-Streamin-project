resource "azurerm_network_interface" "nic01-hub" {
  name                  = "nic-01-hub"
  resource_group_name   = azurerm_resource_group.rg01.name
  location              = azurerm_resource_group.rg01.location
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig-01"
    subnet_id                     = azurerm_subnet.subnet01-vnethub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01-appliance.id

  }
}

resource "azurerm_network_interface" "nic01-frontend" {
  name                = "nic-01-frontend"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  ip_configuration {
    name                          = "ipconfig-01"
    subnet_id                     = azurerm_subnet.subnet01-vnetfrontend.id
    private_ip_address_allocation = "Dynamic"



  }
}
resource "azurerm_network_interface" "nic01-backend" {
  name                = "nic-01-backend"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  ip_configuration {
    name                          = "ipconfig-01"
    subnet_id                     = azurerm_subnet.subnet01-vnetbackend.id
    private_ip_address_allocation = "Dynamic"


  }
}

