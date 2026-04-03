data "azurerm_resources" "list" {
  resource_group_name = "rg-sql-mi"
}

data "azurerm_resource_group" "example" {
  name = "rg-sql-mi"
}

data "azurerm_client_config" "current" {
}

data "azapi_resource_list" "resource_groups" {
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
 
locals {
  matching_resource_groups = [
    for rg in data.azapi_resource_list.resource_groups.output.value : rg
    if try(rg.tags.Workflow, null) == var.workflow
  ]
}
 
resource "terraform_data" "validate_resource_group" {
  lifecycle {
    precondition {
      condition     = length(local.matching_resource_groups) == 1
      error_message = "Expected exactly 1 Resource Group with tag Workflow='${var.workflow}', found ${length(local.matching_resource_groups)}."
    }
  }
}
 
data "azurerm_resource_group" "this" {
  name       = local.matching_resource_groups[0].name
  depends_on = [terraform_data.validate_resource_group]
}
 
 