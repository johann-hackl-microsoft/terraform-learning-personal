resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-azapi-refactor-test"
}

/*
# 1. Start with AzApi generic provider 

resource "azapi_resource" "law" {
  type      = "Microsoft.OperationalInsights/workspaces@2021-12-01-preview"
  name      = var.law_name
  parent_id = azurerm_resource_group.rg.id

  location = azurerm_resource_group.rg.location
  body = jsonencode({
    properties = {
      sku = {
        name = "PerGB2018"
      }
      retentionInDays = 30
    }
  })

  response_export_values = []
}
*/


# 2. Refactor to specific provider

moved {
    from = azapi_resource.law
    to   = azurerm_log_analytics_workspace.law
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
/*
# unfortunately, as of 2024-03-14 not possible: 
# This statement declares a move from azapi_resource.law to azurerm_log_analytics_workspace.law, which is a resource of a different type.
*/