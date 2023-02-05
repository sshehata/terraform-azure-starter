# The central key vault

locals {
  name = "ssglobalvault"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "global_vault" {
  name                        = local.name
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Delete"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "SetSAS",
      "GetSAS",
      "DeleteSAS",
      "Update",
      "RegenerateKey"
    ]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["77.160.160.15"]
  }

  tags = {
    managedBy = "terraform"
  }
}
