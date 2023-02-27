terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.45.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.9.1"
    }
  }
}

