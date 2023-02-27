provider "azurerm" {
  features {}
}

provider "databricks" {
  host = module.databricks_workspace.workspace_url
}
