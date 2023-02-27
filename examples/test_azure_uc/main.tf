resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.prefix}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
}

resource "azurerm_network_security_group" "this" {
  name                = "databricks-nsg-${var.resource_group_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "this" {
  name                = "route-table-${var.resource_group_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

data "azurerm_client_config" "current" {}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

module "databricks_workspace" {
  source                          = "../../modules/azure_vnet_injected_databricks_workspace"
  workspace_name                  = var.databricks_workspace_name
  databricks_resource_group_name  = resource.azurerm_resource_group.this.name
  location                        = var.location
  vnet_id                         = resource.azurerm_virtual_network.this.id
  vnet_name                       = resource.azurerm_virtual_network.this.name
  nsg_id                          = resource.azurerm_network_security_group.this.id
  route_table_id                  = resource.azurerm_route_table.this.id
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  tags                            = local.tags
}

locals {
  prefix                    = var.prefix
  tags = {
    Environment = "TF Demo"
    Owner       = lookup(data.external.me.result, "name")
  }
}

module "unity_catalog" {
  source = "../../modules/azure_uc"

  resource_group_id       = azurerm_resource_group.this.id
  workspaces_to_associate = [module.databricks_workspace.databricks_workspace_id]
}
