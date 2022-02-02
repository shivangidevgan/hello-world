resource "random_string" "rand_passwd" {
  length = 6
  special = true
  lower = false
  upper = false
  number = true
  min_numeric = 3
  min_special = 3
  override_special = "&!$"
}

resource "azurerm_sql_server" "sql_server" {
  name                         = "sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.username
  administrator_login_password = random_string.rand_passwd.result

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_storage_account" "storage_acc" {
  name                     = "neusa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "database" {
  name                = "neusqldatabase"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storage_acc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storage_acc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "Dev"
  }
}