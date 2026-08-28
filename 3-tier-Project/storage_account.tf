resource "azurerm_storage_account" "stream_storage" {
  name                          = "streamvoult0011"
  resource_group_name           = azurerm_resource_group.rg01.name
  location                      = azurerm_resource_group.rg01.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}

resource "azurerm_storage_container" "stream_container" {
  name                  = "video-container"
  storage_account_id    = azurerm_storage_account.stream_storage.id
  container_access_type = "private"
}


resource "azurerm_private_endpoint" "storage-endpoint" {
  name                = "storage-endpoint"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  subnet_id           = azurerm_subnet.subnet01-vnetdatabase.id

  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = azurerm_storage_account.stream_storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage-dns-zone.id]
  }
}

resource "azurerm_private_dns_zone" "storage-dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg01.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "backend-dns-link-storage" {
  name                = "test"
  private_dns_zone_id = azurerm_private_dns_zone.storage-dns-zone.id
  virtual_network_id  = azurerm_virtual_network.vnetbackend.id
}