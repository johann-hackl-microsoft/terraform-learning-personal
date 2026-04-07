terraform {
  required_version = ">= 1.3"


  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.44"
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
