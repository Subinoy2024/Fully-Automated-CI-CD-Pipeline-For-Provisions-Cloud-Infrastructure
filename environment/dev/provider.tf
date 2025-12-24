provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true

    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "3d88343d-13f8-4ac6-9b35-44e30ba1e895"


}
