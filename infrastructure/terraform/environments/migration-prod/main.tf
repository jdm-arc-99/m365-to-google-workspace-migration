locals {
  server_data = csvdecode(file("${path.module}/data.csv"))
}

module "platform" {
  source         = "../../modules/platform-server"
  for_each       = { for s in local.server_data : s.name => s if s.type == "platform" }
  name           = each.value.name
  machine_type   = each.value.machine_type
  zone           = each.value.zone
  project        = var.project
  subnetwork     = var.subnetwork
  installer_url  = var.installer_urls["platform"]
  powershell_url = var.powershell_urls["install"]
}

module "mysql" {
  source         = "../../modules/database-mysql"
  for_each       = { for s in local.server_data : s.name => s if s.type == "mysql" }
  name           = each.value.name
  machine_type   = each.value.machine_type
  zone           = each.value.zone
  project        = var.project
  subnetwork     = var.subnetwork
  installer_url  = var.installer_urls["mysql"]
  powershell_url = var.powershell_urls["mysql"]
}

module "nodes" {
  source         = "../../modules/node-server"
  for_each       = { for s in local.server_data : s.name => s if s.type == "node" }
  name           = each.value.name
  machine_type   = each.value.machine_type
  zone           = each.value.zone
  project        = var.project
  subnetwork     = var.subnetwork
  installer_url  = var.installer_urls["node"]
  powershell_url = var.powershell_urls["node"]
}
