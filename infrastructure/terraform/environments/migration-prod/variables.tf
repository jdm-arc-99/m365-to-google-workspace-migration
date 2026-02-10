variable "project" { type = string }
variable "subnetwork" { type = string }
variable "installer_urls" {
  type = map(string)
  default = {
    platform = "https://storage.googleapis.com/migration-installers/googleware-migrate-platform.msi"
    mysql    = "https://storage.googleapis.com/migration-installers/mysql-installer.msi"
    node     = "https://storage.googleapis.com/migration-installers/google-migrate-node.msi"
  }
}

variable "powershell_urls" {
  type = map(string)
  default = {
    install = "https://storage.googleapis.com/migration-scripts/install.ps1"
    mysql   = "https://storage.googleapis.com/migration-scripts/install_mysql.ps1"
    node    = "https://storage.googleapis.com/migration-scripts/install_node.ps1"
  }
}
