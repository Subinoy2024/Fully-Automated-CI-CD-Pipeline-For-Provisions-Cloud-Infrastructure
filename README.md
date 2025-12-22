terraform-azure-enterprise/
│
├── versions.tf
├── global/
│   ├── locals.tf
│   ├── tags.tf
│   └── naming.tf
│
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   ├── uat/
│   ├── prod/
│   ├── hotfix/
│   └── release/
│
├── modules/
│   ├── azurerm_resource_group/
│   ├── azurerm_virtual_network/
│   ├── azurerm_network_security_group/
│   ├── azurerm_subnet/
│   ├── azurerm_private_endpoint/
│   ├── azurerm_public_internet/
│   ├── azurerm_virtual_machine/
│   ├── azurerm_loadbalancer/
│   ├── azurerm_key_vault/
│   ├── azurerm_storage_account/
│   ├── azurerm_sql_database/
│   ├── azurerm_backup_service/
│   ├── azurerm_monitoring_service/
│   └── azurerm_bastion_service/
│
└── pipelines/
    └── azure-devops-terraform.yml
