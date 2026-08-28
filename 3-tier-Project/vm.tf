resource "azurerm_linux_virtual_machine" "vm-appliaance" {
  name                            = "virtual-appliance-machine"
  resource_group_name             = azurerm_resource_group.rg01.name
  location                        = azurerm_resource_group.rg01.location
  size                            = "Standard_B2als_v2"
  admin_username                  = "azureuser"
  admin_password                  = "Azureuser123#"
  disable_password_authentication = false


  network_interface_ids = [
    azurerm_network_interface.nic01-hub.id,
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "minimal"
    version   = "latest"
  }

  connection {
    type             = "ssh"
    user             = "azureuser"
    password         = "Azureuser123#"
    host             = azurerm_public_ip.pip01-appliance.ip_address
    bastion_user     = "azureuser"
    bastion_password = "Azureuser123#"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sysctl -w net.ipv4.ip_forward=1",
      "sudo sh -c 'echo \"net.ipv4.ip_forward=1\" >> /etc/sysctl.conf'"
    ]
  }


}

resource "azurerm_linux_virtual_machine" "vm-frontend" {
  name                            = "virtual-frontend-machine"
  resource_group_name             = azurerm_resource_group.rg01.name
  location                        = azurerm_resource_group.rg01.location
  size                            = "Standard_B2als_v2"
  admin_username                  = "azureuser"
  admin_password                  = "Azureuser123#"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic01-frontend.id,
  ]



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "minimal"
    version   = "latest"
  }

  connection {
    type             = "ssh"
    user             = "azureuser"
    password         = "Azureuser123#"
    host             = azurerm_network_interface.nic01-frontend.private_ip_address
    bastion_host     = azurerm_public_ip.pip01-appliance.ip_address 
    bastion_user     = "azureuser"
    bastion_password = "Azureuser123#"
  }

  provisioner "file" {
    source      = "c:/Users/raish/Downloads/StreamVault-Project-English/StreamVault-Project-EN/frontend"
    destination = "/home/azureuser/frontend"
  }

  provisioner "remote-exec" {
    inline = [
     
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",

      
      "sudo rm -rf /var/www/html/*",

      
      "sudo cp -r /home/azureuser/frontend/* /var/www/html/",

     
      "sudo chown -R www-data:www-data /var/www/html",
      "sudo chmod -R 755 /var/www/html",

      
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx"
    ]

  }

}


resource "azurerm_linux_virtual_machine" "vm-backend" {
  name                            = "virtual-backend-machine"
  resource_group_name             = azurerm_resource_group.rg01.name
  location                        = azurerm_resource_group.rg01.location
  size                            = "Standard_B2als_v2"
  admin_username                  = "azureuser"
  admin_password                  = "Azureuser123#"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic01-backend.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "minimal"
    version   = "latest"
  }

  depends_on = [
    local_file.backend_env,
    azurerm_mssql_database.sql-database-video,
    azurerm_storage_account.stream_storage,
    azurerm_storage_container.stream_container
  ]

  connection {
    type             = "ssh"
    user             = "azureuser"
    password         = "Azureuser123#"
    host             = azurerm_network_interface.nic01-backend.private_ip_address
    bastion_host     = azurerm_public_ip.pip01-appliance.ip_address
    bastion_user     = "azureuser"
    bastion_password = "Azureuser123#"
    timeout          = "5m"
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p /home/azureuser/videos"]
  }

  provisioner "file" {
    source      = "C:/Users/raish/Downloads/StreamVault-Project-English/StreamVault-Project-EN/backend"
    destination = "/home/azureuser/backend"
  }

  provisioner "file" {
    source      = local_file.backend_env.filename
    destination = "/home/azureuser/backend/.env"
  }

  provisioner "file" {
    source      = "C:/Users/raish/Downloads/ONE MINUTE IN SCOTLAND.mp4"
    destination = "/home/azureuser/videos/ONE MINUTE IN SCOTLAND.mp4"
  }

  provisioner "file" {
    source      = "C:/Users/raish/Downloads/Aurora - Runaway (Lyrics).mp4"
    destination = "/home/azureuser/videos/Aurora - Runaway (Lyrics).mp4"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
      "cd /home/azureuser/backend && sudo npm install",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",

      "curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -",
      "curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list",
      "sudo apt-get update",
      "sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev",
      "/opt/mssql-tools18/bin/sqlcmd -S ${azurerm_mssql_server.sql-server.fully_qualified_domain_name} -U ${azurerm_mssql_server.sql-server.administrator_login} -P '${azurerm_mssql_server.sql-server.administrator_login_password}' -d ${azurerm_mssql_database.sql-database-video.name} -i /home/azureuser/backend/db-setup.sql -C",

      "az storage blob upload --account-name ${azurerm_storage_account.stream_storage.name} --account-key '${azurerm_storage_account.stream_storage.primary_access_key}' --container-name ${azurerm_storage_container.stream_container.name} --file '/home/azureuser/videos/ONE MINUTE IN SCOTLAND.mp4' --name 'ONE MINUTE IN SCOTLAND.mp4'",
      "az storage blob upload --account-name ${azurerm_storage_account.stream_storage.name} --account-key '${azurerm_storage_account.stream_storage.primary_access_key}' --container-name ${azurerm_storage_container.stream_container.name} --file '/home/azureuser/videos/Aurora - Runaway (Lyrics).mp4' --name 'Aurora - Runaway (Lyrics).mp4'",

      "sudo cp /home/azureuser/backend/backend.service /etc/systemd/system/backend.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable backend.service",
      "sudo systemctl start backend.service"
    ]
  }
}