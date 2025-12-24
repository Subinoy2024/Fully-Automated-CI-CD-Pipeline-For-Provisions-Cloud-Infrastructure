variable "environment" {
  type = string
}

variable "location" {
  type = string
}
# variable "subnets" {
#   type = string
# }
variable "vm_admin_username" {
  description = "VM admin username"
  type        = string
  sensitive   = true
}

variable "vm_admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}

variable "sql_admin_username" {
  description = "SQL admin username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}
