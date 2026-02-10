variable "region" { type = string }
variable "project" { type = string }
variable "admin_ip_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
