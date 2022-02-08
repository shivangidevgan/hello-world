provider "azurerm" {
  subscription_id = var.subscriptionid
  features {}
  skip_provider_registration = true
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.91.0"
    }
    
  }
#   backend "azurerm" {
#     container_name = "codetest-statefiles"
#   }
}