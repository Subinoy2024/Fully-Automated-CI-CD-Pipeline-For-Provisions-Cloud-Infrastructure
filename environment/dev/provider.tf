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
  subscription_id = "0d72d6da-117e-4642-81e7-4c2127e41b52"


}
