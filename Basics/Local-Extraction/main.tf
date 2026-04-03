variable "env" {
  type = string
}

locals {
  storage_account_name = "storage${var.env}001"
}

output "storage_account_name" {
  value = local.storage_account_name
}