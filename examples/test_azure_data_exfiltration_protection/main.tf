resource "azurerm_resource_group" "this" {
  name     = var.hub_resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.hub_vnet_address_space]
}

module "spoke_vnet" {
  source                              = "../../modules/azure_spoke_vnet"
  project_name                        = var.project_name
  location                            = azurerm_virtual_network.this.location
  hub_vnet_name                       = azurerm_virtual_network.this.name
  hub_vnet_id                         = azurerm_virtual_network.this.id
  hub_resource_group_name             = azurerm_resource_group.this.name
  firewall_name                       = azurerm_firewall.this.name
  firewall_private_ip                 = azurerm_firewall.this.ip_configuration[0].private_ip_address
  spoke_vnet_address_space            = var.spoke_vnet_address_space
  spoke_resource_group_name           = var.spoke_resource_group_name
  scc_relay_address_prefixes          = var.scc_relay_address_prefixes
  privatelink_subnet_address_prefixes = var.privatelink_subnet_address_prefixes
  webapp_and_infra_routes             = var.webapp_and_infra_routes
  public_repos                        = var.public_repos
  tags                                = var.tags
}

module "spoke_databricks_workspace" {
  source                          = "../../modules/azure_vnet_injected_databricks_workspace"
  workspace_name                  = var.databricks_workspace_name
  databricks_resource_group_name  = module.spoke_vnet.rg_name
  location                        = azurerm_virtual_network.this.location
  vnet_id                         = module.spoke_vnet.vnet_id
  vnet_name                       = module.spoke_vnet.vnet_name
  nsg_id                          = module.spoke_vnet.nsg_id
  route_table_id                  = module.spoke_vnet.route_table_id
  private_subnet_address_prefixes = var.private_subnet_address_prefixes
  public_subnet_address_prefixes  = var.public_subnet_address_prefixes
  tags                            = var.tags
}
