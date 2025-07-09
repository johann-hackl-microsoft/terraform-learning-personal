### Policies of initiative
resource "azurerm_policy_definition" "RequireAppIdTag" {
  name         = "RequireAppIdTag"
  description  = "Requires AppId tag on parent resource group. Not blocking, if resource is not bound to a resource group, like Azure Policies on Subscription level etc."
  policy_type  = "Custom"
  mode         = "All"
  display_name = "RequireAppIdTag"
  policy_rule  = <<POLICY_RULE
  {
    "if": {
        "allOf": [
            {
                "value": "[not(empty(resourceGroup()))]",
                "equals": "true"
            },
            {
                "value": "[empty(trim(resourceGroup().tags.AppId))]",
                "equals": "true"
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
  }
POLICY_RULE
}

### Initiative itself
resource "azurerm_policy_set_definition" "ComplianceInitiative" {
  name         = "ComplianceInitiative"
  description  = "Set of compliance related custom policies."
  policy_type  = "Custom"
  display_name = "ComplianceInitiative"

  # relevant policies as separate reference blocks
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.RequireAppIdTag.id
  }
}

### Subscription level assignment of initiative
resource "azurerm_subscription_policy_assignment" "ComplianceInitiative" {
  name                 = "ComplianceInitiative"
  policy_definition_id = azurerm_policy_set_definition.ComplianceInitiative.id
  subscription_id      = data.azurerm_subscription.current.id
}
