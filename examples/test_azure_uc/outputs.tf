# output "databricks_metastore_id" {
#   value = module.unity_catalog.databricks_metastore_id
# }

output "databricks_host" {
  value = module.databricks_workspace.workspace_url
}

output "databricks_id" {
  value = module.databricks_workspace.databricks_workspace_id
}
