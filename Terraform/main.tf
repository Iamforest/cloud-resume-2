terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azureResume2-rg" {
  name     = "azureResume2.0-rg"
  location = "East US"
}

resource "azurerm_static_web_app" "azureResume2-static-web-app" {
  name                = "azureResume2-static-web-app"
  resource_group_name = azurerm_resource_group.azureResume2-rg.name
  location            = azurerm_resource_group.azureResume2-rg.location
}

# Storage Account for Function App
resource "azurerm_storage_account" "azureResume2storage" {
  name                     = "azureresume2storage"
  resource_group_name      = azurerm_resource_group.azureResume2-rg.name
  location                 = azurerm_resource_group.azureResume2-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# App Service Plan for Function App
resource "azurerm_service_plan" "azureResume2-service-plan" {
  name                = "azureResume2-service-plan"
  resource_group_name = azurerm_resource_group.azureResume2-rg.name
  location            = azurerm_resource_group.azureResume2-rg.location
  os_type             = "Linux"
  sku_name            = "Y1" # Consumption plan
}

# Application Insights for monitoring
resource "azurerm_application_insights" "azureResume2-app-insights" {
  name                = "azureResume2-app-insights"
  resource_group_name = azurerm_resource_group.azureResume2-rg.name
  location            = azurerm_resource_group.azureResume2-rg.location
  application_type    = "web"
}

# Linux Function App with Python runtime
resource "azurerm_linux_function_app" "azureResume2-function-app" {
  name                       = "azureResume2-function-app"
  resource_group_name        = azurerm_resource_group.azureResume2-rg.name
  location                   = azurerm_resource_group.azureResume2-rg.location
  service_plan_id            = azurerm_service_plan.azureResume2-service-plan.id
  storage_account_name       = azurerm_storage_account.azureResume2storage.name
  storage_account_access_key = azurerm_storage_account.azureResume2storage.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
    use_32_bit_worker = false
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.azureResume2-app-insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.azureResume2-app-insights.instrumentation_key
  }
}

resource "azurerm_cosmosdb_account" "azureResume2-cosmosdb-account" {
  name                = "azureresume2-cosmosdb-account"
  location            = azurerm_resource_group.azureResume2-rg.location
  resource_group_name = azurerm_resource_group.azureResume2-rg.name
  offer_type          = "Standard"

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = azurerm_resource_group.azureResume2-rg.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
}

resource "azurerm_cosmosdb_sql_database" "azureResume2-cosmosdb-database" {
  name                = "azureResume2-cosmosdb-database"
  resource_group_name = azurerm_cosmosdb_account.azureResume2-cosmosdb-account.resource_group_name
  account_name        = azurerm_cosmosdb_account.azureResume2-cosmosdb-account.name
}

resource "azurerm_cosmosdb_sql_container" "azureResume2-cosmosdb-container" {
  name                = "azureResume2-cosmosdb-container"
  resource_group_name = azurerm_cosmosdb_account.azureResume2-cosmosdb-account.resource_group_name
  account_name        = azurerm_cosmosdb_account.azureResume2-cosmosdb-account.name
  database_name       = azurerm_cosmosdb_sql_database.azureResume2-cosmosdb-database.name
  partition_key_paths = ["/counter/id"]
  throughput          = 400

}

