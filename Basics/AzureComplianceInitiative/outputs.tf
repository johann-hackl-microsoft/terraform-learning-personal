output "Initiative_Definition_ID" {
  value = azurerm_policy_set_definition.ComplianceInitiative.id
}

output "Initiative_Assignment_ID" {
  value = azurerm_subscription_policy_assignment.ComplianceInitiative.id
}
