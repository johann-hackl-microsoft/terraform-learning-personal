terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>2.5"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

data "azurerm_subscription" "current" {}
