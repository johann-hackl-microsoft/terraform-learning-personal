terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "=0.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}
