variable "network_name" {
  type    = string
  default = "migration-vpc"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "region" {
  type = string
}

variable "admin_ip_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"] # Should be restricted in production
}
