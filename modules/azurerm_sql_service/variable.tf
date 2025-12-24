variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sql_server_name" {
  description = "SQL Server name"
  type        = string
}

variable "administrator_login" {
  description = "SQL admin username"
  type        = string
  sensitive   = true

}

variable "administrator_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true

}

variable "sql_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "vnet_name" {
  description = "VNet name (for PE readiness)"
  type        = string
  
}

variable "subnet_name" {
  description = "Subnet name (for PE readiness)"
  type        = string
}

variable "databases" {
  description = "Databases to create on the SQL server"
  type = map(object({
    name        = string
    sku_name    = string
    max_size_gb = number
  }))
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
