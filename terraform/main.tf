terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}
provider "azurerm" {
  subscription_id = var.subscriptionid
  features {}
  skip_provider_registration = true
}

module "acr" {
  source = "./modules/acr"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "storage_acc" {
  source = "./modules/storage_acc"
  resource_group_name = var.resource_group_name
  location = var.location
  username = var.username
}

module "loadbalancer"{
  source = "./modules/loadbalancer"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "vnet"{
  source = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location = var.location
}