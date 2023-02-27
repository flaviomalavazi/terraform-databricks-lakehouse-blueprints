variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group to be created"
}

variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "(Required) The address space for the injected VNET"
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  description = "(Required) The address space for the private subnet"
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  description = "(Required) The address space for the public subnet"
}

variable "databricks_workspace_name" {
  type        = string
  description = "(Required) The Databricks workspace name"
}

variable "prefix" {
  type        = string
  description = "(Required) The Deployment prefix for the resources"
}
