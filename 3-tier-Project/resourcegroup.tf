locals {
  name     = "3-tier-rg"
  location = "Central India"
}
resource "azurerm_resource_group" "rg01" {
  name     = local.name
  location = local.location
}