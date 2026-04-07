output "original_tags" { 
  value = local.existing_identity_tags 
}

output "updated_tags" {
  value = azurerm_user_assigned_identity.example.tags
}
