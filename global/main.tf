# global cloud resources and infrastructure

locals {
  name = "infrastructure"
}

# resource group
module "global_resource_group" {
  source = "../modules/resources/resource-group"

  name = local.name
}

# tf-backend
module "terraform_backend" {
  source = "../modules/services/tf-backend"

  resource_group_name     = module.global_resource_group.name
  resource_group_location = module.global_resource_group.location

  vault_id = module.default_keyvault.id
}


module "default_keyvault" {
  source = "../modules/services/vault"

  resource_group_name     = module.global_resource_group.name
  resource_group_location = module.global_resource_group.location
}
