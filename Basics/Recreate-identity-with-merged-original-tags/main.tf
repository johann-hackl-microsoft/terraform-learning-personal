# we have to use and enable the below blocks later once tested locally
data "azurerm_subscription" "current" {}
data "azapi_resource_list" "existing_identity" {
  parent_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.rg_name}"
  type      = "Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30"

  response_export_values = {
    filtered = "value[?name=='${var.uai_name}' && contains(id, '/resourceGroups/${var.rg_name}/')]"
  }
}
locals {
  existing_identity_tags = length(data.azapi_resource_list.existing_identity.output.filtered) > 0 ? data.azapi_resource_list.existing_identity.output.filtered[0].tags : {}
}

# Create a new User Assigned Identity with the same tags as the existing VM, plus the Workflow tag
resource "azurerm_user_assigned_identity" "example" {
  name                = var.uai_name
  resource_group_name = var.rg_name
  location            = var.location
  tags = merge(
    local.existing_identity_tags,
    {
      "Tag-1" = "a"
      "Tag-2" = "b"
      "Tag-3" = "c"
      "Tag-4" = "d"
      "Tag-5" = "e"
    }
  )
}

# Manually create the resource group, then apply, add some tags manually to the identity in Azure Portal and then change the location value to test a recreation, whereby the additional manual tags should be preserved.
