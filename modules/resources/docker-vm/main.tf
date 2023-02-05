# docker vm
# An single vm in it's own subnet with auxiliary resources and docker enabled

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_space

  lifecycle {
    create_before_destroy = true
  }
}

# associate nsg with subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_public_ip" "ip" {
  name                = "${var.name}-ip"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.name}-vm"
  resource_group_name   = var.resource_group.name
  location              = var.resource_group.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  # hostname
  computer_name = var.name

  # OS image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "100"
  }

  disable_password_authentication = true
  admin_username                  = "ubuntu"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  # run startup script
  user_data = filebase64("${path.module}/scripts/startup.sh")

  tags = {
    environment = var.environment
  }
}
