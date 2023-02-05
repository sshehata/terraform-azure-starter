# generate provider block
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

EOF
}

#remote_state {
#  backend = "azurerm"
#  generate = {
#    path      = "backend.tf"
#    if_exists = "overwrite_terragrunt"
#  }
#  
#  config = {
#        key = "${path_relative_to_include()}/terraform.tfstate"
#        resource_group_name = "infrastructure"
#        storage_account_name = "sstfbackend"
#        container_name = "sstfbackend"
#    }
#}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
       azurerm = {
         source  = "hashicorp/azurerm"
         version = ">=3.9.0"
       }
      }
    }
EOF
}