# resource_group
# An azure resource group located in the west-europe region

resource "azurerm_resource_group" "west_europe_rg" {
  name     = var.name
  location = "West Europe"

  tags = {
    "managedBy" = "terraform"
  }
}
