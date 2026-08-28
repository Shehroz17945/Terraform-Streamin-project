resource "azurerm_mssql_server" "sql-server" {
  name                          = "sqlserver-video-stream01"
  resource_group_name           = azurerm_resource_group.rg01.name
  location                      = azurerm_resource_group.rg01.location
  version                       = "12.0"
  administrator_login           = "sqladmin2026"
  administrator_login_password  = "Vaporvm123#$"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "sql-database-video" {
  name         = "sql-database-video"
  server_id    = azurerm_mssql_server.sql-server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "S4"
  enclave_type = "VBS"

}

resource "azurerm_private_endpoint" "sql-endpoint" {
  name                = "sql-endpoint"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  subnet_id           = azurerm_subnet.subnet01-vnetdatabase.id

  private_service_connection {
    name                           = "sql-connection"
    private_connection_resource_id = azurerm_mssql_server.sql-server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql-dns.id]
  }
}

resource "azurerm_private_dns_zone" "sql-dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg01.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "backend-dns-link-sql" {
  name                = "test"
  private_dns_zone_id = azurerm_private_dns_zone.sql-dns.id
  virtual_network_id  = azurerm_virtual_network.vnetbackend.id
}