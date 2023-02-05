# playground
# A playground docker enabled vm
#
#

locals {
  name = "playground"
}

# resource group
module "project_resource_group" {
  source = "../../modules/resources/resource-group"

  name = local.name
}

# virtual network (Vnet) within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name}-vnet"
  resource_group_name = module.project_resource_group.name
  location            = module.project_resource_group.location
  address_space       = ["10.0.0.0/16"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.name}-nsg"
  resource_group_name = module.project_resource_group.name
  location            = module.project_resource_group.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "77.160.160.15/32"
    destination_address_prefix = "*"
  }
}

# playground-vm
# This is a playground environment where developers are free to make any changes, test/prototype features and deploy developement versions.
module "playground_server" {
  source = "../../modules/services/docker-vm"

  name = "playground"
  resource_group = {
    location = module.project_resource_group.location
    name     = module.project_resource_group.name
  }

  vnet_name                 = azurerm_virtual_network.vnet.name
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_address_space      = ["10.0.1.0/24"]
  environment               = "playground"
}
