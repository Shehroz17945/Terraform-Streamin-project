resource "local_file" "backend_env" {
  content = templatefile("${path.module}/env.tpl", {
    db_server             = azurerm_mssql_server.sql-server.fully_qualified_domain_name
    db_name               = azurerm_mssql_database.sql-database-video.name
    db_user               = azurerm_mssql_server.sql-server.administrator_login
    db_password           = azurerm_mssql_server.sql-server.administrator_login_password
    jwt_secret             = var.jwt_secret
    storage_account_name   = azurerm_storage_account.stream_storage.name
    storage_account_key    = azurerm_storage_account.stream_storage.primary_access_key
  })
  filename = "${path.module}/generated.env"
}