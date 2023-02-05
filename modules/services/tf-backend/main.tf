# tf-backend
# storage account to be used by terraform itself as a backend
locals {
  name = "sstfbackend"
}

# storage account
resource "azurerm_storage_account" "storageaccount" {
  name                     = local.name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = ["77.160.160.15"]
  }

  tags = {
    managedBy = "terraform"
  }
}

# blob storage container
resource "azurerm_storage_container" "container" {
  name                  = local.name
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}


# configure key management and automatic rotation

# identity for the key vault responsible for rotating the keys
data "azuread_service_principal" "azure_government" {
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}

# role assignment for identity that grants permission to rotate keys
resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_storage_account.storageaccount.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = data.azuread_service_principal.azure_government.id
}

# key management policy
resource "azurerm_key_vault_managed_storage_account" "managed_storage_account" {
  name                         = local.name
  key_vault_id                 = var.vault_id
  storage_account_id           = azurerm_storage_account.storageaccount.id
  storage_account_key          = "key1"
  regenerate_key_automatically = true
  regeneration_period          = "P1D"

  depends_on = [
    azurerm_role_assignment.role_assignment,
  ]
}
