output "name" {
  value = var.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

# output "compute_environment" {
#   value = var.compute_environment
# }

output "asp" {
  value = data.azurerm_service_plan.asp
}