output "resource_list" {
  value = data.azurerm_resources.list.resources.*.name
}
output "resource_group_name" {
  value = data.azurerm_resource_group.example.name
}
output "resource_group_names" {
  value = data.azapi_resource_list.resource_groups.output
}
output "azurerm_resource_group_id" {
  value = data.azurerm_resource_group.this.id
}