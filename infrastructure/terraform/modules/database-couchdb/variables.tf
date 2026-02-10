variable "name" { type = string }
variable "machine_type" { type = string; default = "n1-standard-4" }
variable "zone" { type = string }
variable "project" { type = string }
variable "os_family" { type = string; default = "windows-2019" }
variable "disk_size" { type = number; default = 100 }
variable "subnetwork" { type = string }
variable "admin_username" { type = string; default = "couchdb-admin" }
variable "installer_url" { type = string }
variable "powershell_url" { type = string }
