resource "azurerm_route_table" "rt_backend" {
  name                = "rt-hub-nva"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  route {
    name                   = "route-to-databse"
    address_prefix         = "11.0.0.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_network_interface.nic01-hub.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "rt_associationa_backend" {
  subnet_id      = azurerm_subnet.subnet01-vnetbackend.id
  route_table_id = azurerm_route_table.rt_backend.id
}
