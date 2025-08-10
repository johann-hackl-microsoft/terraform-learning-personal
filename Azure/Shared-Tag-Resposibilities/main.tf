data "azapi_resource_list" "existing_rg" {
  parent_id = data.azurerm_subscription.current.id
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  # parent_id can be omitted; defaults to current subscription
  
  # Keep only the RG whose name exactly matches var.rg_name
  response_export_values = {
    # Returns a list with 0 or 1 element(s)
    filtered = "value[?name=='${var.rg_name}']"
  }
}

locals {
  existing_tags = length(data.azapi_resource_list.existing_rg.output.filtered) > 0 ? data.azapi_resource_list.existing_rg.output.filtered[0].tags  : {}
}

resource "azurerm_resource_group" "managed" {
  name     = var.rg_name
  location = "SwedenCentral"
  tags = merge(
    local.existing_tags,
    var.enforced_tags
  )
}

output "original_tags" { 
  value = local.existing_tags 
}

output "update_rg" {
  value = azurerm_resource_group.managed.tags
}

# References
# - azapi_resource_list (Data Source): https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/resource_list
# - 
